Imports System
Imports System.IO
Imports System.Text

Module Program
    Sub Main(args As String())
        If args.Length < 2 Then
            ToonHelp()
            Return
        End If
        Dim commando As String = args(0).ToLower()
        Dim dskPad As String = args(1)
        Try
            Select Case commando
                Case "create"
                    If args.Length < 3 Then
                        Console.WriteLine("Fout: Geef formaat op (360k of 720k).")
                        Return
                    End If
                    MaakDsk(dskPad, args(2).ToLower())
                Case "format"
                    FormatteerDsk(dskPad)
                Case "add"
                    If args.Length < 3 Then
                        Console.WriteLine("Fout: Geef het toe te voegen pc-bestand of wildcard op.")
                        Return
                    End If
                    VerwerkAddCommando(args, dskPad)
                Case "extract"
                    If args.Length < 3 Then
                        Console.WriteLine("Fout: Geef het MSX-bestand/pad op.")
                        Return
                    End If
                    Dim pcDoelPad As String = ""
                    If args.Length >= 4 Then pcDoelPad = args(3)
                    ExporteerBestand(dskPad, args(2), pcDoelPad)
                Case "del"
                    If args.Length < 3 Then
                        Console.WriteLine("Fout: Geef het te verwijderen MSX-bestand op.")
                        Return
                    End If
                    VerwijderBestandofMap(dskPad, args(2), False)
                Case "mkdir"
                    If args.Length < 3 Then
                        Console.WriteLine("Fout: Geef de mapnaam op.")
                        Return
                    End If
                    MaakMap(dskPad, args(2))
                Case "rmdir"
                    If args.Length < 3 Then
                        Console.WriteLine("Fout: Geef de te verwijderen map op.")
                        Return
                    End If
                    VerwijderBestandofMap(dskPad, args(2), True)
                Case "list"
                    ToonInhoud(dskPad)
                Case "label"
                    Dim nieuweNaam As String = ""
                    If args.Length >= 3 Then nieuweNaam = args(2)
                    BeheerDiskNaam(dskPad, nieuweNaam)
                Case Else
                    ToonHelp()
            End Select
        Catch ex As Exception
            Console.WriteLine("Kritieke fout: " & ex.Message)
        End Try
    End Sub
    Sub ToonHelp()
        Console.WriteLine("=== MSX DSK CLI Tool Pro v2 ===")
        Console.WriteLine("Gebruik:")
        Console.WriteLine("  msxdsk create  <image.dsk> <360k|720k>")
        Console.WriteLine("  msxdsk format  <image.dsk>")
        Console.WriteLine("  msxdsk list    <image.dsk>")
        Console.WriteLine("  msxdsk label   <image.dsk> [nieuwe_naam]")
        Console.WriteLine("  msxdsk mkdir   <image.dsk> <msx_pad/nieuwe_map>")
        Console.WriteLine("  msxdsk rmdir   <image.dsk> <msx_pad/map>")
        Console.WriteLine("  msxdsk add     <image.dsk> <pc_bestand_of_wildcard> [msx_doelpad] [attributen]")
        Console.WriteLine("  msxdsk extract <image.dsk> <msx_bronpad> [pc_doelbestand]")
        Console.WriteLine("  msxdsk del     <image.dsk> <msx_pad/bestandsnaam>")
        Console.WriteLine("Attributen: R = Read-Only (1), H = Hidden (2), S = System (4)")
    End Sub

    Function HaalAttribuutOp(attrStr As String) As Byte
        Dim res As Byte = 0
        Dim s As String = attrStr.ToUpper()
        If s.Contains("R") Then res = res Or 1
        If s.Contains("H") Then res = res Or 2
        If s.Contains("S") Then res = res Or 4
        Return res
    End Function

    Sub VerwerkAddCommando(args As String(), dskPad As String)
        Dim pcInput As String = args(2)
        Dim msxDoelPad As String = ""
        Dim attr As Byte = 0
        
        If args.Length = 4 Then
            Dim checkAttr As String = args(3).ToUpper()
            Dim isAlleenAttr As Boolean = True
            For i As Integer = 0 To checkAttr.Length - 1
                Dim c As Char = checkAttr.Chars(i)
                If c <> "R"c And c <> "H"c And c <> "S"c Then isAlleenAttr = False
            Next
            If isAlleenAttr And checkAttr <> "" Then
                attr = HaalAttribuutOp(checkAttr)
                msxDoelPad = ""
            Else
                msxDoelPad = args(3)
            End If
        ElseIf args.Length >= 5 Then
            msxDoelPad = args(3)
            attr = HaalAttribuutOp(args(4))
        End If
        
        Dim mapPad As String = Path.GetDirectoryName(pcInput)
        If mapPad = "" Then mapPad = Directory.GetCurrentDirectory()
        Dim filter As String = Path.GetFileName(pcInput)
        
        If filter.Contains("*") Or filter.Contains("?") Then
            Dim bestanden As String() = Directory.GetFiles(mapPad, filter)
            If bestanden.Length = 0 Then
                Console.WriteLine("Geen bestanden gevonden die voldoen aan: " & filter)
                Return
            End If
            For Each bestEn As String In bestanden
                Dim fInf As New FileInfo(bestEn)
                Dim subDoel As String = msxDoelPad
                If subDoel <> "" AndAlso Not subDoel.EndsWith("/") Then subDoel &= "/"
                VoegBestandToe(dskPad, bestEn, subDoel & fInf.Name, attr)
            Next
        Else
            VoegBestandToe(dskPad, pcInput, msxDoelPad, attr)
        End If
    End Sub

    Sub VoegBestandToe(dskPad As String, pcBestandPad As String, msxDoelPad As String, attribuut As Byte)
        If Not File.Exists(pcBestandPad) Then
            Console.WriteLine("Fout: Lokaal pc-bestand bestaat niet: " & pcBestandPad)
            Return
        End If
        Dim dsk As Byte() = File.ReadAllBytes(dskPad)
        Dim pcData As Byte() = File.ReadAllBytes(pcBestandPad)

        Dim fInfo As New FileInfo(pcBestandPad)
        Dim targetPad As String = msxDoelPad
        If targetPad = "" OrElse targetPad.EndsWith("/") Then
            targetPad = targetPad & fInfo.Name
        End If

        Dim pCluster As UShort = 0 : Dim rOffset As Integer = -1 : Dim isMap As Boolean = False
        Dim bestCluster As UShort = ZoekPadClusterEnOffset(dsk, targetPad, pCluster, rOffset, isMap)

        If rOffset <> -1 AndAlso (dsk(rOffset + 11) And 1) = 1 Then
            Console.WriteLine("Fout: Doelbestand is Read-Only! Sla over: " & targetPad)
            Return
        End If

        Dim duren As String() = targetPad.ToUpper().Split("/"c)
        Dim msxNaam As String = duren(duren.Length - 1)
        Dim np As String() = msxNaam.Split("."c)
        Dim naamPart As String = np(0).PadRight(8, " "c).Substring(0, 8)
        Dim extPart As String = "   "
        If np.Length > 1 Then extPart = np(1).PadRight(3, " "c).Substring(0, 3)

        If rOffset <> -1 Then
            VrijmakenFatKeten(dsk, bestCluster)
            Console.WriteLine("Bestand bestaat al. Bezig met updaten: " & targetPad)
        Else
            rOffset = ZoekVrijeRecordOffset(dsk, pCluster)
        End If

        Dim sectorsPerCluster As Byte = dsk(13)
        Dim bytesPerCluster As Integer = sectorsPerCluster * 512
        Dim benodigdeClusters As Integer = Math.Max(1, CInt(Math.Ceiling(pcData.Length / bytesPerCluster)))
        Dim vorigeCluster As UShort = 0 : Dim eersteCluster As UShort = 0

        For c As Integer = 0 To benodigdeClusters - 1
            Dim vrijeCluster As UShort = ZoekVrijeCluster(dsk)
            If vrijeCluster = 0 Then
                Console.WriteLine("Fout: Geen schijfruimte meer over op de image.")
                Return
            End If
            
            ' FIX: Claim de cluster DIRECT tijdelijk in de FAT zodat deze niet dubbel wordt uitgegeven!
            SchrijfFatEntry(dsk, vrijeCluster, &HFFF)
            
            If c = 0 Then eersteCluster = vrijeCluster
            If vorigeCluster <> 0 Then SchrijfFatEntry(dsk, vorigeCluster, vrijeCluster)

            Dim fatSectors As Byte = dsk(22)
            Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
            Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)
            Dim clusterDataOffset As Integer = (dataStartSector + (vrijeCluster - 2) * sectorsPerCluster) * 512
            Dim bytesToCopy As Integer = Math.Min(bytesPerCluster, pcData.Length - (c * bytesPerCluster))
            Array.Copy(pcData, c * bytesPerCluster, dsk, clusterDataOffset, bytesToCopy)
            vorigeCluster = vrijeCluster
        Next

        SchrijfFatEntry(dsk, vorigeCluster, &HFFF)
        Encoding.ASCII.GetBytes(naamPart).CopyTo(dsk, rOffset)
        Encoding.ASCII.GetBytes(extPart).CopyTo(dsk, rOffset + 8)
        dsk(rOffset + 11) = attribuut
        BitConverter.GetBytes(eersteCluster).CopyTo(dsk, rOffset + 26)
        BitConverter.GetBytes(CUInt(pcData.Length)).CopyTo(dsk, rOffset + 28)

        File.WriteAllBytes(dskPad, dsk)
        Console.WriteLine("Succesvol toegevoegd: " & targetPad)
    End Sub

    Sub ExporteerBestand(dskPad As String, msxBronPad As String, pcDoelPad As String)
        Dim dsk As Byte() = File.ReadAllBytes(dskPad)
        Dim pCluster As UShort = 0 : Dim rOffset As Integer = -1 : Dim isMap As Boolean = False
        Dim startCluster As UShort = ZoekPadClusterEnOffset(dsk, msxBronPad, pCluster, rOffset, isMap)

        If rOffset = -1 Or isMap Then
            Console.WriteLine("Fout: MSX bestand niet gevonden of het is een map.")
            Return
        End If

        Dim grootte As UInteger = BitConverter.ToUInt32(dsk, rOffset + 28)
        Dim pcOutputPad As String = pcDoelPad
        If pcOutputPad = "" Then
            Dim duren As String() = msxBronPad.Split("/"c)
            pcOutputPad = duren(duren.Length - 1)
        End If

        Dim sectorsPerCluster As Byte = dsk(13)
        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)

        Dim pcData(grootte - 1) As Byte
        Dim huidigeCluster As UShort = startCluster
        Dim bytesTotaalGelezen As Integer = 0

        While huidigeCluster <> 0 AndAlso huidigeCluster < &HFF8
            Dim clusterOffset As Integer = (dataStartSector + (huidigeCluster - 2) * sectorsPerCluster) * 512
            Dim overig As Integer = CInt(grootte) - bytesTotaalGelezen
            Dim teLezen As Integer = Math.Min(sectorsPerCluster * 512, overig)

            Array.Copy(dsk, clusterOffset, pcData, bytesTotaalGelezen, teLezen)
            bytesTotaalGelezen += teLezen
            If bytesTotaalGelezen >= grootte Then Exit While

            huidigeCluster = LeesFatEntry(dsk, huidigeCluster)
        End While

        File.WriteAllBytes(pcOutputPad, pcData)
        Console.WriteLine("Bestand succesvol geëxtraheerd naar PC: " & pcOutputPad)
    End Sub

    Sub FormatteerDsk(pad As String)
        If Not File.Exists(pad) Then
            Console.WriteLine("Fout: Het bestand bestaat niet.")
            Return
        End If
        Dim dsk As Byte() = File.ReadAllBytes(pad)
        
        Dim sectorsPerCluster As Byte = dsk(13)
        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim mediaId As Byte = dsk(21)
        
        Dim fat1Start As Integer = 512
        Dim fat2Start As Integer = 512 + (fatSectors * 512)
        Dim rootStart As Integer = 512 + (2 * fatSectors * 512)
        Dim rootGrootte As Integer = rootEntries * 32

        Array.Clear(dsk, fat1Start, fatSectors * 512)
        Array.Clear(dsk, fat2Start, fatSectors * 512)

        dsk(fat1Start) = mediaId : dsk(fat1Start + 1) = &HFF : dsk(fat1Start + 2) = &HFF
        dsk(fat2Start) = mediaId : dsk(fat2Start + 1) = &HFF : dsk(fat2Start + 2) = &HFF

        Array.Clear(dsk, rootStart, rootGrootte)

        File.WriteAllBytes(pad, dsk)
        Console.WriteLine("De disk image is succesvol leeggemaakt (Snel geformatteerd).")
    End Sub

    Sub MaakMap(dskPad As String, msxNieuwPad As String)
        Dim dsk As Byte() = File.ReadAllBytes(dskPad)
        Dim pCluster As UShort = 0 : Dim rOffset As Integer = -1 : Dim isMap As Boolean = False
        Try
            Dim testClus As UShort = ZoekPadClusterEnOffset(dsk, msxNieuwPad, pCluster, rOffset, isMap)
            If rOffset <> -1 Then
                Console.WriteLine("Fout: Naam of map bestaat al.")
                Return
            End If
        Catch ex As Exception
        End Try

        Dim duren As String() = msxNieuwPad.ToUpper().Split("/"c)
        Dim mapNaam As String = duren(duren.Length - 1)
        Dim naamPart As String = mapNaam.PadRight(8, " "c).Substring(0, 8)

        rOffset = ZoekVrijeRecordOffset(dsk, pCluster)
        Dim vrijeCluster As UShort = ZoekVrijeCluster(dsk)
        If vrijeCluster = 0 Then
            Console.WriteLine("Fout: Geen vrije ruimte.")
            Return
        End If

        SchrijfFatEntry(dsk, vrijeCluster, &HFFF)
        Encoding.ASCII.GetBytes(naamPart).CopyTo(dsk, rOffset)
        Encoding.ASCII.GetBytes("   ").CopyTo(dsk, rOffset + 8)
        dsk(rOffset + 11) = 16
        BitConverter.GetBytes(vrijeCluster).CopyTo(dsk, rOffset + 26)
        BitConverter.GetBytes(CUInt(0)).CopyTo(dsk, rOffset + 28)

        Dim sectorsPerCluster As Byte = dsk(13)
        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)
        Dim mapOffset As Integer = (dataStartSector + (vrijeCluster - 2) * sectorsPerCluster) * 512

        Array.Clear(dsk, mapOffset, sectorsPerCluster * 512)
        Encoding.ASCII.GetBytes(".       ").CopyTo(dsk, mapOffset)
        Encoding.ASCII.GetBytes("   ").CopyTo(dsk, mapOffset + 8)
        dsk(mapOffset + 11) = 16
        BitConverter.GetBytes(vrijeCluster).CopyTo(dsk, mapOffset + 26)

        Encoding.ASCII.GetBytes("..      ").CopyTo(dsk, mapOffset + 32)
        Encoding.ASCII.GetBytes("   ").CopyTo(dsk, mapOffset + 40)
        dsk(mapOffset + 43) = 16
        BitConverter.GetBytes(pCluster).CopyTo(dsk, mapOffset + 58)

        File.WriteAllBytes(dskPad, dsk)
        Console.WriteLine("Submap succesvol aangemaakt: " & msxNieuwPad)
    End Sub

    Sub VerwijderBestandofMap(dskPad As String, msxPad As String, moetMapZijn As Boolean)
        Dim dsk As Byte() = File.ReadAllBytes(dskPad)
        Dim pCluster As UShort = 0 : Dim rOffset As Integer = -1 : Dim isMap As Boolean = False
        Dim startCluster As UShort = ZoekPadClusterEnOffset(dsk, msxPad, pCluster, rOffset, isMap)

        If rOffset = -1 Then
            Console.WriteLine("Fout: Object niet gevonden.")
            Return
        End If
        If (dsk(rOffset + 11) And 1) = 1 Then
            Console.WriteLine("Fout: Object is Read-Only!")
            Return
        End If
        If moetMapZijn And Not isMap Then
            Console.WriteLine("Fout: Opgegeven pad is geen map.")
            Return
        End If

        If isMap Then
            Dim sectorsPerCluster As Byte = dsk(13)
            Dim fatSectors As Byte = dsk(22)
            Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
            Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)
            Dim mapOffset As Integer = (dataStartSector + (startCluster - 2) * sectorsPerCluster) * 512
            
            For i As Integer = 2 To ((sectorsPerCluster * 512) \ 32) - 1
                Dim checkOff As Integer = mapOffset + (i * 32)
                If dsk(checkOff) <> &H0 AndAlso dsk(checkOff) <> &HE5 Then
                    Console.WriteLine("Fout: Map is niet leeg!")
                    Return
                End If
            Next
        End If

        VrijmakenFatKeten(dsk, startCluster)
        dsk(rOffset) = &HE5
        File.WriteAllBytes(dskPad, dsk)
        Console.WriteLine("Succesvol verwijderd van DSK.")
    End Sub

    Function ZoekVrijeRecordOffset(dsk As Byte(), cluster As UShort) As Integer
        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim sectorsPerCluster As Byte = dsk(13)
        Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)
        Dim records As Integer = (sectorsPerCluster * 512) \ 32
        If cluster = 0 Then records = rootEntries

        Dim hCluster As UShort = cluster
        While True
            Dim startOffset As Integer = 512 + (2 * fatSectors * 512)
            If hCluster <> 0 Then
                startOffset = (dataStartSector + (hCluster - 2) * sectorsPerCluster) * 512
            End If
            For i As Integer = 0 To records - 1
                Dim offset As Integer = startOffset + (i * 32)
                If dsk(offset) = &H0 OrElse dsk(offset) = &HE5 Then Return offset
            Next
            If hCluster = 0 Then Exit While
            Dim vCluster As UShort = LeesFatEntry(dsk, hCluster)
            If vCluster >= &HFF8 Then
                Dim nCluster As UShort = ZoekVrijeCluster(dsk)
                If nCluster = 0 Then Throw New Exception("Schijf vol.")
                SchrijfFatEntry(dsk, hCluster, nCluster)
                SchrijfFatEntry(dsk, nCluster, &HFFF)
                Dim nOffset As Integer = (dataStartSector + (nCluster - 2) * sectorsPerCluster) * 512
                Array.Clear(dsk, nOffset, sectorsPerCluster * 512)
                Return nOffset
            End If
            hCluster = vCluster
        End While
        Throw New Exception("Directory limiet bereikt.")
    End Function

    Function LeesFatEntry(dsk As Byte(), cluster As UShort) As UShort
        Dim fatOffset As Integer = 512 + ((cluster * 3) \ 2)
        Dim b1 As Byte = dsk(fatOffset) : Dim b2 As Byte = dsk(fatOffset + 1)
        If (cluster And 1) = 0 Then
            Return CUShort(((b2 And &HF) << 8) Or b1)
        Else
            Return CUShort((b2 << 4) Or (b1 >> 4))
        End If
    End Function

    Sub SchrijfFatEntry(dsk As Byte(), cluster As UShort, waarde As UShort)
        Dim fatSectors As Byte = dsk(22)
        Dim fat1Offset As Integer = 512 + ((cluster * 3) \ 2)
        Dim fat2Offset As Integer = fat1Offset + (fatSectors * 512)
        Dim offsets(1) As Integer
        offsets(0) = fat1Offset : offsets(1) = fat2Offset

        For i As Integer = 0 To 1
            Dim offset As Integer = offsets(i)
            If (cluster And 1) = 0 Then
                dsk(offset) = CByte(waarde And &HFF)
                dsk(offset + 1) = CByte((dsk(offset + 1) And &HF0) Or ((waarde >> 8) And &HF))
            Else
                dsk(offset) = CByte((dsk(offset) And &HF) Or ((waarde And &HF) << 4))
                dsk(offset + 1) = CByte((waarde >> 4) And &HFF)
            End If
        Next
    End Sub

    Function ZoekVrijeCluster(dsk As Byte()) As UShort
        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim sectorsPerCluster As Byte = dsk(13)
        Dim totaalSectors As Integer = BitConverter.ToUInt16(dsk, 19)
        
        Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)
        Dim maxCluster As Integer = 2 + ((totaalSectors - dataStartSector) \ sectorsPerCluster)

        For c As UShort = 2 To CUShort(maxCluster - 1)
            If LeesFatEntry(dsk, c) = 0 Then Return c
        Next
        Return 0
    End Function

    Sub VrijmakenFatKeten(dsk As Byte(), startCluster As UShort)
        Dim huidigeCluster As UShort = startCluster
        While huidigeCluster <> 0 AndAlso huidigeCluster < &HFF8
            Dim volgendeCluster As UShort = LeesFatEntry(dsk, huidigeCluster)
            SchrijfFatEntry(dsk, huidigeCluster, 0)
            huidigeCluster = volgendeCluster
        End While
    End Sub

    Sub MaakDsk(pad As String, formaat As String)
        Dim totaalSectors As Integer = 1440 
        Dim sectorsPerCluster As Byte = 2 
        Dim fatSectors As Byte = 3
        Dim mediaId As Byte = &HF9
        Dim aantalKoppen As Byte = 2
        
        If formaat = "360k" Then 
            totaalSectors = 720 
            sectorsPerCluster = 1 
            fatSectors = 2 
            mediaId = &HF8 
            aantalKoppen = 1
        End If

        Dim rootEntries As UShort = 112 
        Dim data(totaalSectors * 512 - 1) As Byte
        
        data(0) = &HEB : data(1) = &HFE : data(2) = &H90
        Encoding.ASCII.GetBytes("MSX-DOS ").CopyTo(data, 3)
        
        data(11) = 0 : data(12) = 2                   ' Bytes per sector (512)
        data(13) = sectorsPerCluster                  ' Adres 0x0D: Sectors per cluster
        data(14) = 1 : data(15) = 0                   ' Gereserveerde sectors (1)
        data(16) = 2                                  ' Aantal FATs (2)
        
        data(17) = CByte(rootEntries And &HFF)        ' Root entries (112)
        data(18) = CByte((rootEntries >> 8) And &HFF)
        
        data(19) = CByte(totaalSectors And &HFF)      ' Totaal aantal sectors
        data(20) = CByte((totaalSectors >> 8) And &HFF)
        
        data(21) = mediaId                            ' Media Descriptor
        data(22) = fatSectors : data(23) = 0          ' Sectoren per FAT
        
        data(24) = 9 : data(25) = 0                   ' Adres 0x18: Sectoren per track (9)
        data(26) = aantalKoppen                       ' Adres 0x1A: Aantal magneetkoppen (1 of 2)
        data(27) = 0                                  ' Adres 0x1B: Gereserveerde hidden sectors
        
        ' Officiële MSX-DOS Boot Routine vanaf adres 0x1E
        Dim bootCode() As Byte = {
            &HD0, &HED, &H53, &H59, &HC0, &H32, &HD0, &HC0, &H36, &H56, &H23, &H36, &HC0, &H31, &H1F, &HF5,
            &H11, &HAB, &HC0, &H0E, &H0F, &HCD, &H7D, &HF3, &H3C, &HCA, &H63, &HC0, &H11, &H00, &H01, &H0E,
            &H1A, &HCD, &H7D, &HF3, &H21, &H01, &H00, &H22, &HB9, &HC0, &H21, &H00, &H3F, &H11, &HAB, &HC0,
            &H0E, &H27, &HCD, &H7D, &HF3, &HC3, &H00, &H01, &H58, &HC0, &HCD, &H00, &H00, &H79, &HE6, &HFE,
            &HFE, &H02, &HC2, &H6A, &HC0, &H3A, &HD0, &HC0, &HA7, &HCA, &H22, &H40, &H11, &H85, &HC0, &HCD,
            &H77, &HC0, &H0E, &H07, &HCD, &H7D, &HF3, &H18, &HB4, &H1A, &HB7, &HC8, &HD5, &H5F, &H0E, &H06,
            &HCD, &H7D, &HF3, &HD1, &H13, &H18, &HF2, &H42, &H6F, &H6F, &H74, &H20, &H65, &H72, &H72, &H6F,
            &H72, &H0D, &H0A, &H50, &H72, &H65, &H73, &H73, &H20, &H61, &H6E, &H79, &H20, &H6B, &H65, &H79,
            &H20, &H66, &H6F, &H72, &H20, &H72, &H65, &H74, &H72, &H79, &H0D, &H0A, &H00, &H00, &H4D, &H53,
            &H58, &H44, &H4F, &H53, &H20, &H20, &H53, &H59, &H53
        }
        bootCode.CopyTo(data, &H1E)
        
        Dim fat1Start As Integer = 512 : Dim fat2Start As Integer = 512 + (fatSectors * 512)
        data(fat1Start) = mediaId : data(fat1Start + 1) = &HFF : data(fat1Start + 2) = &HFF
        data(fat2Start) = mediaId : data(fat2Start + 1) = &HFF : data(fat2Start + 2) = &HFF
        
        File.WriteAllBytes(pad, data)
        Console.WriteLine("Succesvol aangemaakt: " & pad & " (" & formaat & ").")
    End Sub

    Sub ToonInhoud(pad As String)
        Dim dsk As Byte() = File.ReadAllBytes(pad)
        Console.WriteLine("Inhoud van MSX Disk (Recursieve scan):")
        Console.WriteLine("Naam         Type  Grootte (Bytes)  Attr  Cluster  Pad")
        Console.WriteLine("----------------------------------------------------------------------")
        ScanMapRecursief(dsk, 0, "")
    End Sub

    Sub ScanMapRecursief(dsk As Byte(), cluster As UShort, huidigPad As String)
        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim sectorsPerCluster As Byte = dsk(13)
        Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)
        Dim records As Integer = (sectorsPerCluster * 512) \ 32
        If cluster = 0 Then records = rootEntries

        Dim hCluster As UShort = cluster
        While True
            Dim startOffset As Integer = 512 + (2 * fatSectors * 512)
            If hCluster <> 0 Then
                startOffset = (dataStartSector + (hCluster - 2) * sectorsPerCluster) * 512
            End If

            For i As Integer = 0 To records - 1
                Dim offset As Integer = startOffset + (i * 32)
                Dim status As Byte = dsk(offset)
                If status = &H0 And hCluster = 0 Then Return
                If status = &H0 Then Exit For
                If status = &HE5 Then Continue For

                Dim naam As String = Encoding.ASCII.GetString(dsk, offset, 8).TrimEnd()
                Dim ext As String = Encoding.ASCII.GetString(dsk, offset + 8, 3).TrimEnd()
                Dim attr As Byte = dsk(offset + 11)
                
                If (attr And 8) = 8 Then Continue For
                If naam.StartsWith(".") Then Continue For

                Dim grootte As UInteger = BitConverter.ToUInt32(dsk, offset + 28)
                Dim startClus As UShort = BitConverter.ToUInt16(dsk, offset + 26)

                Dim volledigeNaam As String = naam
                If ext <> "" Then volledigeNaam = naam & "." & ext
                Dim weergavePad As String = huidigPad & "/" & volledigeNaam

                Dim typeStr As String = "FILE"
                If (attr And 16) = 16 Then typeStr = "DIR "
                Dim attrStr As String = ""
                attrStr &= If((attr And 1) = 1, "R", "-")
                attrStr &= If((attr And 2) = 2, "H", "-")
                attrStr &= If((attr And 4) = 4, "S", "-")

                Console.WriteLine(String.Format("{0,-12} {1}  {2,-15}  {3}   {4,-7}  {5}", volledigeNaam, typeStr, grootte, attrStr, startClus, weergavePad))

                If (attr And 16) = 16 AndAlso startClus <> 0 Then
                    ScanMapRecursief(dsk, startClus, huidigPad & "/" & volledigeNaam)
                End If
            Next

            If hCluster = 0 Then Exit While
            hCluster = LeesFatEntry(dsk, hCluster)
            If hCluster >= &HFF8 Then Exit While
        End While
    End Sub

    Function ZoekPadClusterEnOffset(dsk As Byte(), VolledigPad As String, ByRef uitParentCluster As UShort, ByRef uitRecordOffset As Integer, ByRef isMap As Boolean) As UShort
        Dim delen As String() = VolledigPad.ToUpper().Split("/"c)
        Dim huidigeCluster As UShort = 0
        uitParentCluster = 0
        uitRecordOffset = -1
        isMap = False

        Dim fatSectors As Byte = dsk(22)
        Dim rootEntries As Integer = BitConverter.ToUInt16(dsk, 17)
        Dim sectorsPerCluster As Byte = dsk(13)
        Dim dataStartSector As Integer = 1 + (2 * fatSectors) + ((rootEntries * 32) \ 512)

        For d As Integer = 0 To delen.Length - 1
            Dim deel As String : deel = delen(d).Trim()
            If deel = "" Then Continue For

            Dim naamPart As String : naamPart = deel
            Dim extPart As String : extPart = "   "
            If deel.Contains(".") Then
                Dim duren As String() : duren = deel.Split("."c)
                naamPart = duren(0)
                extPart = duren(1)
            End If
            naamPart = naamPart.PadRight(8, " "c).Substring(0, 8)
            extPart = extPart.PadRight(3, " "c).Substring(0, 3)

            Dim gevonden As Boolean : gevonden = False
            Dim records As Integer : records = (sectorsPerCluster * 512) \ 32
            If huidigeCluster = 0 Then records = rootEntries
            Dim hCluster As UShort : hCluster = huidigeCluster

            While True
                Dim startOffset As Integer : startOffset = 512 + (2 * fatSectors * 512)
                If hCluster <> 0 Then
                    startOffset = (dataStartSector + (hCluster - 2) * sectorsPerCluster) * 512
                End If

                For i As Integer = 0 To records - 1
                    Dim offset As Integer : offset = startOffset + (i * 32)
                    If dsk(offset) = &H0 And hCluster = 0 Then Exit While
                    If dsk(offset) = &H0 Then Exit For
                    If dsk(offset) = &HE5 Then Continue For

                    If Encoding.ASCII.GetString(dsk, offset, 8) = naamPart AndAlso Encoding.ASCII.GetString(dsk, offset + 8, 3) = extPart Then
                        uitParentCluster = huidigeCluster
                        uitRecordOffset = offset
                        huidigeCluster = BitConverter.ToUInt16(dsk, offset + 26)
                        isMap = ((dsk(offset + 11) And 16) = 16)
                        gevonden = True
                        Exit While
                    End If
                Next

                If hCluster = 0 Then Exit While
                hCluster = LeesFatEntry(dsk, hCluster)
                If hCluster >= &HFF8 Then Exit While
            End While

            If Not gevonden Then
                If d = delen.Length - 1 Then
                    uitParentCluster = AdministrativeCluster(huidigeCluster)
                    Return 0
                Else
                    Throw New Exception("Pad-onderdeel '" & deel & "' niet gevonden.")
                End If
            End If
        Next
        Return huidigeCluster
    End Function

    Function AdministrativeCluster(clus As UShort) As UShort
        Return clus
    End Function

    Sub BeheerDiskNaam(pad As String, nieuweNaam As String)
        If Not File.Exists(pad) Then
            Console.WriteLine("Fout: Disk image bestaat niet.")
            Return
        End If
        Dim dsk As Byte() = File.ReadAllBytes(pad)
        If nieuweNaam = "" Then
            Console.WriteLine("Huidige disknaam (OEM Name): '" & Encoding.ASCII.GetString(dsk, 3, 8) & "'")
        Else
            Dim geformatteerdeNaam As String = nieuweNaam.PadRight(8, " "c)
            If geformatteerdeNaam.Length > 8 Then geformatteerdeNaam = geformatteerdeNaam.Substring(0, 8)
            Encoding.ASCII.GetBytes(geformatteerdeNaam).CopyTo(dsk, 3)
            File.WriteAllBytes(pad, dsk)
            Console.WriteLine("Disknaam succesvol gewijzigd naar: '" & geformatteerdeNaam & "'")
        End If
    End Sub
End Module

