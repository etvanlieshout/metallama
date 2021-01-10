;
; **** ZP ABSOLUTE ADRESSES **** 
;
a00 = $00
a01 = $01
a02 = $02
a03 = $03
a04 = $04
a05 = $05
a07 = $07
a09 = $09
a0A = $0A
a0B = $0B
a0C = $0C
a0E = $0E
a10 = $10
a11 = $11
a12 = $12
a13 = $13
a14 = $14
a15 = $15
a16 = $16
a17 = $17
a18 = $18
a19 = $19
a1A = $1A
a1B = $1B
a1C = $1C
a1D = $1D
a1E = $1E
a1F = $1F
a20 = $20
a21 = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a27 = $27
a28 = $28
a29 = $29
aC5 = $C5
;
; **** ZP POINTERS **** 
;
p00 = $00
;
; **** FIELDS **** 
;
f0340 = $0340
f0360 = $0360
f037F = $037F
f0383 = $0383
f0384 = $0384
f0387 = $0387
f0388 = $0388
f038B = $038B
f038C = $038C
f1F00 = $1F00
f1FCD = $1FCD
f1FDC = $1FDC
fC000 = $C000
fC001 = $C001
fC042 = $C042
;
; **** ABSOLUTE ADRESSES **** 
;
a0291 = $0291
a0380 = $0380
a0382 = $0382
a0386 = $0386
a1EE5 = $1EE5
a1EE6 = $1EE6
a1EF1 = $1EF1
a1FD9 = $1FD9
a1FEF = $1FEF
a1FF0 = $1FF0
a97D9 = $97D9
a97DA = $97DA
a97DB = $97DB
;
; **** POINTERS **** 
;
p03 = $0003
p13 = $0013
p0107 = $0107
p0417 = $0417
p0A00 = $0A00
p0A07 = $0A07
;
; **** PREDEFINED LABELS **** 
;
RAM_CINV = $0314
VICCR4 = $9004
VICCR5 = $9005
VICCRA = $900A
VICCRB = $900B
VICCRC = $900C
VICCRD = $900D
VICCRE = $900E
VICCRF = $900F
VIA1IER = $911E
VIA1PA2 = $911F
VIA2PB = $9120
VIA2DDRB = $9122

        * = $1001

        .BYTE $0D,$10,$0A,$00,$9E,$28,$34,$31
        .BYTE $31,$31,$29,$00
        BRK #$00
        JMP j1B55

s1012   LDA #$1E
        STA a01
        LDA #$00
        STA a00
        LDX #$00
b101C   LDA a00
        STA f0340,X
        LDA a01
        STA f0360,X
        LDA a00
        CLC 
        ADC #$16
        STA a00
        LDA a01
        ADC #$00
        STA a01
        INX 
        CPX #$1B
        BNE b101C
        RTS 

s1039   LDX a03
        LDY a02
        LDA f0340,X
        STA a00
        LDA f0360,X
        STA a01
        RTS 

s1048   TXA 
        PHA 
        TYA 
        PHA 
        JSR s1039
        LDA (p00),Y
        STA a07
b1053   JMP j1079

s1056   LDA a02
        AND #$80
        BEQ b105D
        RTS 

b105D   TXA 
        PHA 
        TYA 
        PHA 
        LDA a02
        CMP #$28
        BPL b1053
        JSR s1039
        LDA a04
        STA (p00),Y
        LDA a01
        CLC 
        ADC #$78
        STA a01
        LDA a05
        STA (p00),Y
j1079   PLA 
        TAY 
        PLA 
        TAX 
        LDA a07
        RTS 

s1080   LDX #$00
b1082   LDA #$00
        STA $1E00,X
        STA f1F00,X
        DEX 
        BNE b1082
        RTS 

j108E   JSR s1012
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        LDA #$00
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDA #$FF
        STA VICCR5   ;$9005 - screen map & character map address
        JSR s10B1
        JMP j111B

s10B1   JSR s1080
        LDA #$01
        STA a05
        LDA #>p1400
        STA a03
        LDA #<p1400
        STA a02
        LDA #$26
        STA a04
b10C4   JSR s1056
        INC a02
        LDA a02
        CMP #$16
        BNE b10C4
        INC a03
        LDA #$07
        STA a05
        LDX #$00
        STX a02
b10D9   LDA f1105,X
        STA a04
        JSR s1056
        INC a02
        INX 
        CPX #$16
        BNE b10D9
        INC a03
        LDA #$08
        STA a02
        LDX #$00
b10F0   LDA f1100,X
        STA a04
        JSR s1056
        INC a02
        INX 
        CPX #$05
        BNE b10F0
        RTS 

f1100   .TEXT "<=>00"
f1105   .TEXT "0000000", $00, "*+,000%0000000"
j111B   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        STA a1D
j1120   LDA #$01
        STA a28
        JSR s194D
        LDA #$03
        STA a29
        LDX #$07
        LDA #$30
b112F   STA f1FCD,X
        DEX 
        BNE b112F
j1135   LDA a28
        CLC 
        ADC #$10
        STA a25
j113C   LDA #$0A
        STA a10
        JSR s1A44
        LDY #$20
        LDX a28
b1147   DEY 
        BEQ b114D
        DEX 
        BNE b1147
b114D   INY 
        TYA 
        STA a26
        STA a1C
        LDA #$01
        STA a11
        STA a1F
        STA a12
        STA a16
        LDA #<p03
        STA a17
        LDA #>p03
        STA a18
        LDA #$07
        STA a24
        LDA #$30
        STA a1FD9
        LDA #$FF
        LDX #$04
b1172   STA f037F,X
        DEX 
        BNE b1172
        LDX #$16
b117A   STA f1B7F,X
        DEX 
        BNE b117A
        JSR s1B0E
        LDA a28
        ASL 
        STA a09
        LDA #$C0
        SEC 
        SBC a09
        STA a27
        JMP j11CA

s1192   SEI 
        LDX #$7F
        STX VIA2DDRB ;$9122 - data direction register for port b
b1198   LDY VIA2PB   ;$9120 - port b I/O register
        CPY VIA2PB   ;$9120 - port b I/O register
        BNE b1198
        LDX #$FF
        STX VIA2DDRB ;$9122 - data direction register for port b
        LDX #$F7
        STX VIA2PB   ;$9120 - port b I/O register
        CLI 
b11AB   LDA VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        CMP VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        BNE b11AB
        PHA 
        AND #$1C
        LSR 
        CPY #$80
        BCC b11BD
        ORA #$10
b11BD   TAY 
        PLA 
        AND #$20
        CMP #$20
        TYA 
        ROR 
        EOR #$8F
        STA a13
        RTS 

j11CA   JSR s11DC
        JSR s1325
        JSR s14E8
        JSR s1755
        JSR s1312
        JMP j11CA

s11DC   DEC a14
        BEQ b11E1
        RTS 

b11E1   LDA #$50
        STA a14
        LDA a18
        BEQ b11EB
        DEC a18
b11EB   LDA a11
        BNE b1254
        LDA a10
        STA a15
        JSR s1192
        LDA a13
        AND #$04
        BEQ b120C
        LDA #$00
        STA a12
        DEC a10
        LDA a10
        CMP #$01
        BNE b120C
        LDA #$13
        STA a10
b120C   LDA a13
        AND #$08
        BEQ b1222
        LDA #$01
        STA a12
        INC a10
        LDA a10
        CMP #$14
        BNE b1222
        LDA #$02
        STA a10
b1222   LDA #$12
        STA a03
        LDA a10
        CMP a15
        BEQ b1254
        LDA #$12
        STA a03
        LDA #$01
        STA a11
        LDA a15
        STA a02
        JSR s12A5
        LDA #$05
        STA a04
        LDA a12
        BNE b1247
        LDA #$0F
        STA a04
b1247   LDA a10
        STA a02
        LDA a12
        BEQ b1251
        DEC a02
b1251   JMP j12BE

b1254   LDA #$12
        STA a03
        LDA a10
        STA a02
        LDA #$00
        STA a11
        LDA a12
        BEQ b1266
        DEC a02
b1266   JSR s127C
        LDA #$01
        STA a04
        LDA a12
        BNE b1275
        LDA #$0B
        STA a04
b1275   LDA a10
        STA a02
        JMP j12F1

s127C   LDA #$00
        STA a04
        JSR s1056
        LDA a02
        PHA 
        INC a02
        JSR s1056
        INC a02
        JSR s1056
        PLA 
        STA a02
        INC a03
        JSR s1056
        INC a02
        JSR s1056
        INC a02
        JSR s1056
        DEC a03
        RTS 

s12A5   LDA #$00
        STA a04
        JSR s1056
        INC a02
        JSR s1056
        INC a03
        JSR s1056
        DEC a02
        JSR s1056
        DEC a03
        RTS 

j12BE   LDA #$07
        STA a05
        JSR s1056
        LDA a02
        PHA 
        INC a04
        INC a02
        JSR s1056
        INC a04
        INC a02
        JSR s1056
        PLA 
        STA a02
        INC a03
        INC a04
        JSR s1056
        INC a02
        INC a04
        JSR s1056
        INC a02
        INC a04
        JSR s1056
        DEC a03
        RTS 

j12F1   LDA #$07
        STA a05
        JSR s1056
        INC a04
        INC a02
        JSR s1056
        DEC a02
        INC a03
        INC a04
        JSR s1056
        INC a02
        INC a04
        JSR s1056
        DEC a03
        RTS 

s1312   LDX #$01
b1314   LDY #$40
b1316   DEY 
        BNE b1316
        DEX 
        BNE b1314
        RTS 

f131D   .BYTE $00
f131E   .BYTE $06,$02,$04,$05,$03,$07,$01
s1325   DEC a1A
        BEQ b132A
b1329   RTS 

b132A   LDA #$10
        STA a1A
        JSR s13AE
        DEC a16
        BNE b1329
        LDA #$02
        STA a16
        JSR s1192
        LDA a17
        STA a03
        LDA #$00
        STA a02
        STA a04
b1346   JSR s1048
        CMP #$1B
        BNE b1350
        JSR s1056
b1350   INC a02
        LDA a02
        CMP #$16
        BNE b1346
        LDA a13
        AND #$01
        BEQ b1368
        DEC a17
        LDA a17
        CMP #$FF
        BNE b1368
        INC a17
b1368   LDA a13
        AND #$02
        BEQ b1378
        INC a17
        LDA a17
        CMP #$0A
        BNE b1378
        DEC a17
b1378   LDA #$00
        STA a02
        LDA #$1B
        STA a04
        LDX a18
        LDA f131E,X
        STA a05
        LDA a17
        STA a03
b138B   JSR s1048
        BNE b1393
        JSR s1056
b1393   INC a02
        LDA a02
        CMP #$16
        BNE b138B
        LDX VICCR4   ;$9004 - raster beam location (bits 7-0)
        LDA fC000,X
        STA a1CDB
        LDA fC001,X
        STA a1CDC
f13AA   RTS 

        .BYTE $07,$03,$06
s13AE   LDA a0380
        CMP #$FF
        BEQ b13B8
        JMP j13F9

b13B8   LDA a13
        AND #$80
        BNE b13BF
        RTS 

b13BF   LDX #$03
        LDA #$06
        STA a23
        LDA #$F0
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #>p0107
        STA a0A
        LDA #<p0107
        STA a09
        JSR s1829
b13D5   LDA #$11
        STA f0383,X
        LDY a10
        LDA a12
        BNE b13E3
        DEY 
        DEY 
        DEY 
b13E3   INY 
        INY 
        TYA 
        STA f037F,X
        LDA a12
        STA f0387,X
        LDA #$00
        STA f038B,X
        DEX 
        BNE b13D5
        JMP j1448

j13F9   LDA a0382
        STA a02
p1400   =*+$02
        LDA a0386
        STA a03
        LDA #$00
        STA a04
        JSR s1056
        LDX #$02
b140C   LDA f037F,X
        STA a0380,X
        LDA f0383,X
        STA f0384,X
        LDA f0387,X
        STA f0388,X
        LDA f038B,X
        STA f038C,X
        DEX 
        BNE b140C
        LDA a0380
        STA a19
        LDA f0388
        BNE b1437
        DEC a0380
        DEC a0380
b1437   INC a0380
        LDA f038C
        BNE b1445
        DEC f0384
        DEC f0384
b1445   INC f0384
j1448   LDA a0380
        AND #$80
        BNE b1459
        LDA a0380
        CMP #$16
        BEQ b1459
        JMP j1466

b1459   LDA a19
        STA a0380
        LDA f0388
        EOR #$01
        STA f0388
j1466   LDA f0384
        CMP a17
        BMI b148C
        JMP j14A3

j1470   LDX #$03
b1472   LDA f037F,X
        STA a02
        LDA f0383,X
        STA a03
        LDA #$00
        STA a04
        JSR s1056
        LDA #$FF
        STA f037F,X
        DEX 
        BNE b1472
        RTS 

b148C   LDA a17
        STA f0384
        LDA #$01
        STA f038C
        LDA #$04
        STA a22
        LDA #$E8
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$06
        STA a18
j14A3   LDX #$03
b14A5   LDA f13AA,X
        STA a05
        LDA f037F,X
        STA a02
        LDA f0383,X
        STA a03
        LDY #$16
        LDA f0387,X
        BNE b14BC
        DEY 
b14BC   LDA f038B,X
        BEQ b14CA
        CPY #$16
        BNE b14C9
        DEY 
        JMP b14CA

b14C9   INY 
b14CA   STY a04
        JSR s1048
        JSR s1670
        BNE b14D7
        JMP j1470

b14D7   JSR s1056
        DEX 
        BNE b14A5
        LDA f0384
        CMP #$13
        BNE b14E7
        JMP j1470

b14E7   RTS 

s14E8   DEC a1B
        BEQ b14ED
        RTS 

b14ED   LDA a27
        STA a1B
        LDA a1D31
        ROL 
        ADC #$00
        STA a1D31
        EOR #$FF
        STA a1D32
        JSR s1813
        INC a1F
        INC a1E
        LDA a1F
        AND #$01
        STA a1F
        DEC a1C
        BEQ b1513
        JMP j1543

b1513   LDA a26
        STA a1C
        LDX #$16
b1519   LDA f1B7F,X
        CMP #$FF
        BEQ b1526
        DEX 
        BNE b1519
        JMP j1543

b1526   INC a1D
        LDY a1D
        LDA fC042,Y
        AND #$1F
        CMP #$16
        BPL b1526
        STA f1B7F,X
        LDA #$01
        STA f1B9F,X
        STA f1BDF,X
        LDA #$00
        STA f1BBF,X
j1543   LDX #$16
b1545   LDA f1B7F,X
        CMP #$FF
        BNE b154F
        JMP j157B

b154F   LDA f1BBF,X
        BNE b155A
        JSR s157F
        JMP j157B

b155A   CMP #$01
        BNE b1564
        JSR s15D2
        JMP j157B

b1564   CMP #$02
        BNE b156E
        JSR s160E
        JMP j157B

b156E   CMP #$03
        BNE b1578
        JSR s17B9
        JMP j157B

b1578   JSR s1641
j157B   DEX 
        BNE b1545
        RTS 

s157F   LDA #$00
        STA a03
        LDA f1B7F,X
        STA a02
        LDA #>p0417
        STA a05
        LDA #<p0417
        STA a04
b1590   JSR s1056
        INC a03
        LDA a03
        CMP f1B9F,X
        BNE b1590
        LDA #$1C
        CLC 
        ADC f1BDF,X
        STA a04
        JSR s1056
        INC f1BDF,X
        LDA f1BDF,X
        AND #$01
        STA f1BDF,X
        BNE b15BE
        INC f1B9F,X
        LDA f1B9F,X
        CMP #$0F
        BEQ b15BF
b15BE   RTS 

b15BF   LDA #$01
        STA f1BBF,X
        LDA #$00
        STA f1BDF,X
        DEC f1B9F,X
f15CC   RTS 

        .BYTE $17,$18,$19,$1A,$00
s15D2   LDA #$00
        STA a03
        LDA f1B7F,X
        STA a02
        INC f1BDF,X
        LDA f1BDF,X
        CMP #$06
        BEQ b1608
        TAY 
        LDA f15CC,Y
        STA a04
        LDA a1E
        AND #$07
        STA a05
b15F1   JSR s1056
        INC a03
        LDA a03
        CMP f1B9F,X
        BNE b15F1
        LDA #$1C
        STA a04
        LDA #$03
        STA a05
        JMP s1056

b1608   LDA #$02
        STA f1BBF,X
        RTS 

s160E   LDA f1B7F,X
        STA a02
        LDA f1B9F,X
        STA a03
        LDA #$00
        STA a04
        JSR s1884
        INC f1B9F,X
        INC a03
        LDA #$03
        STA a05
        LDA #$1E
        STA a04
        JSR s1884
        LDA a03
        CMP #$13
        BEQ b1636
        RTS 

b1636   LDA #$03
        STA f1BBF,X
        LDA #$01
        STA f1BDF,X
        RTS 

s1641   LDA f1B7F,X
        STA a02
        LDA f1B9F,X
        STA a03
        LDA f1BDF,X
        STA a04
        INC f1BBF,X
        LDA f1BBF,X
        AND #$07
        STA a05
        JSR s1056
        LDA f1BBF,X
        BEQ b1663
        RTS 

b1663   LDA #$00
        STA a04
        JSR s1056
        LDA #$FF
        STA f1B7F,X
        RTS 

s1670   CMP #$17
        BNE b16B2
        LDX #$16
b1676   LDA f1B7F,X
        CMP a02
        BEQ b1683
b167D   DEX 
        BNE b1676
        LDA #$00
        RTS 

b1683   LDA f1BBF,X
        BNE b167D
        LDA #$01
        STA f1BBF,X
        LDA #$00
        STA f1BDF,X
        LDA #$08
        STA a24
        LDA #$10
        SEC 
        SBC f1B9F,X
        CLC 
        ROR 
        CLC 
        STA a0A
        PHA 
        LDA #$05
        STA a09
        JSR s1829
        PLA 
        ADC #$30
        STA a1FD9
        LDA #$00
        RTS 

b16B2   CMP #$1C
        BEQ b16BD
        CMP #$1D
        BEQ b16BD
        JMP j16F3

b16BD   JSR s173C
        LDA #$F0
        STA f1BBF,X
        LDA #$1F
        STA f1BDF,X
        STA a04
        LDA #$01
        JSR s1846
        JSR s1056
        LDA #$00
        STA a04
        LDA f1B7F,X
        STA a02
        LDA #$00
        STA a03
b16E1   JSR s1056
        INC a03
        LDA a03
        CMP f1B9F,X
        BNE b16E1
        JSR s17AF
        LDA #$00
        RTS 

j16F3   CMP #$1E
        BNE b1714
        JSR s173C
        LDA #$F0
        STA f1BBF,X
        LDA #$20
        STA f1BDF,X
        STA a04
        LDA #$04
        JSR s1846
        JSR s1056
        JSR s17AF
        LDA #$00
        RTS 

b1714   CMP #$28
        BEQ b171F
        CMP #$29
        BEQ b171F
        LDA #$FF
        RTS 

b171F   JSR s173C
        LDA #$F0
        STA f1BBF,X
        LDA #$21
        STA f1BDF,X
        STA a04
        LDA #$06
        JSR s1846
        JSR s1056
        JSR s17AF
        LDA #$00
        RTS 

s173C   LDX #$16
b173E   LDA f1B7F,X
        CMP a02
        BEQ b174D
b1745   DEX 
        BNE b173E
        PLA 
        PLA 
        LDA #$00
        RTS 

b174D   LDA f1B9F,X
        CMP a03
        BNE b1745
        RTS 

s1755   DEC a20
        BEQ b175A
        RTS 

b175A   LDA #$10
        STA a20
        LDA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        AND #$80
        BEQ b1773
        INC VICCRA   ;$900A - frequency of sound osc.1 (bass)
        BNE b1773
        DEC a21
        BEQ b1773
        LDA #$F8
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
b1773   LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        AND #$80
        BEQ b1794
        DEC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        CMP #$E0
        BNE b1794
        LDA #$00
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        BNE b1794
        DEC a22
        BEQ b1794
        LDA #$E8
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b1794   LDA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        AND #$80
        BEQ b17AE
        INC VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        CMP #$FE
        BNE b17AE
        DEC a23
        BNE b17AE
        LDA #$F0
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b17AE   RTS 

s17AF   LDA #$F8
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        LDA #$04
        STA a21
        RTS 

s17B9   LDA #<p13
        STA a03
        LDA #>p13
        STA a04
        LDA #$03
        STA a05
        LDA a1F
        BNE b1803
        LDA f1B7F,X
        STA a02
        CMP a10
        BMI b17EA
        JSR s1884
        DEC f1BDF,X
        LDA f1BDF,X
        CMP #$FF
        BNE b1803
        LDA #$01
        STA f1BDF,X
        DEC f1B7F,X
        JMP b1803

b17EA   INC f1BDF,X
        LDA f1BDF,X
        CMP #$02
        BNE b1803
        LDA #$00
        STA a04
        JSR s1056
        LDA #$00
        STA f1BDF,X
        INC f1B7F,X
b1803   LDA f1B7F,X
        STA a02
        LDA #$29
        SEC 
        SBC f1BDF,X
        STA a04
        JMP s1884

s1813   LDA a24
        BNE b1818
        RTS 

b1818   DEC a24
        LDX a24
        LDA f131D,X
        STA a97D9
        STA a97DA
        STA a97DB
        RTS 

s1829   TXA 
        PHA 
b182B   LDX a09
b182D   INC f1FCD,X
        LDA f1FCD,X
        CMP #$3A
        BNE b183F
        LDA #$30
        STA f1FCD,X
        DEX 
        BNE b182D
b183F   DEC a0A
        BNE b182B
        PLA 
        TAX 
        RTS 

s1846   STA a0A
        LDA #$05
        STA a09
        JSR s1829
        DEC a25
        JSR s1B0E
        LDA a25
        BEQ b1879
        LDA a25
        AND #$03
        CMP #$03
        BNE b1866
        DEC a26
        BNE b1866
        INC a26
b1866   LDA #$04
        STA a09
b186A   DEC a27
        LDA a27
        CMP #$30
        BNE b1874
        INC a27
b1874   DEC a09
        BNE b186A
        RTS 

b1879   INC a28
        JSR s1902
        JSR s18E4
        JMP j1135

s1884   JSR s1048
        BEQ b1898
        STA a09
        AND #$80
        BNE b1898
        LDA #$14
        CMP a09
        BMI b1898
        JMP j189B

b1898   JMP s1056

j189B   LDA #$00
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$80
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b18AB   LDA #$20
        STA a0A
b18AF   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$00
        BNE b18AF
        LDX #$08
        LDA VICCRF   ;$900F - screen colors: background, border & inverse
        CMP #$08
        BNE b18C1
        LDX #$2A
b18C1   STX VICCRF   ;$900F - screen colors: background, border & inverse
        DEC a0A
        BNE b18AF
        DEC VICCRE   ;$900E - sound volume
        BNE b18AB
        LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        DEC a29
        BNE b18DE
        JMP j1AB4

b18DE   JSR s18E4
        JMP j113C

s18E4   LDA #>p00
        STA a03
b18E8   LDA #<p00
        STA a02
        STA a04
b18EE   JSR s1056
        INC a02
        LDA a02
        CMP #$16
        BNE b18EE
        INC a03
        LDA a03
        CMP #$14
        BNE b18E8
        RTS 

s1902   LDA #$00
        STA VICCR4   ;$9004 - raster beam location (bits 7-0)
        STA a0A
        STA a0B
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
j1914   INC a0B
        LDA a0B
        AND #$07
        TAX 
        LDA f131D,X
        AND #$0F
        ORA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDY #$30
b1927   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        BEQ b1932
        DEY 
        BNE b1927
        JMP j1914

b1932   LDA #$00
        STA a0B
        LDA a0A
        ASL 
        ASL 
        ASL 
        ORA #$80
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        DEC a0A
        BNE j1914
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        RTS 

s194D   JSR s18E4
        LDA #>p0A00
        STA a03
        LDA #<p0A00
        STA a02
        TAX 
b1959   LDA f19C0,X
        AND #$3F
        ORA #$80
        STA a04
        LDA #$01
        STA a05
        JSR s1056
        LDA #$06
        STA a03
        LDA f19E3,X
        AND #$3F
        ORA #$80
        STA a04
        JSR s1056
        LDA #$0A
        STA a03
        INC a02
        INX 
        CPX #$16
        BNE b1959
        JSR s1A24
        LDA #$00
        STA a0A
        STA a0C
b198D   LDA a0C
        STA a0B
j1991   INC a0B
        LDA a0B
        AND #$07
        TAX 
        LDA f131D,X
        ORA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDY a0B
b19A2   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        BEQ b19B3
        LDA aC5
        CMP #$40
        BNE b19D6
b19AD   DEY 
        BNE b19A2
        JMP j1991

b19B3   DEC a0A
        BNE b198D
        LDA #$05
        STA a0A
        INC a0C
        JMP b198D

f19C0   .TEXT "F1:LEVEL 00   F7:BEGIN"
b19D6   CMP #$27
        BEQ b19F9
        CMP #$3F
        BNE b19AD
        LDA #$08
        JMP j1B70

f19E3   .TEXT "(C)  1983    LLAMASOFT"
b19F9   INC a28
        LDA a28
        CMP #$21
        BNE b1A05
        LDA #$01
        STA a28
b1A05   JSR s1A24
        LDA #$30
        STA a0E
b1A0C   LDX #$00
b1A0E   LDA a0E
        ORA #$80
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        DEX 
        BNE b1A0E
        DEC a0E
        BNE b1A0C
        LDA #$00
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        JMP b19AD

s1A24   LDA #$30
        STA a1EE5
        STA a1EE6
        LDX a28
b1A2E   INC a1EE6
        LDA a1EE6
        CMP #$3A
        BNE b1A40
        LDA #$30
        STA a1EE6
        INC a1EE5
b1A40   DEX 
        BNE b1A2E
        RTS 

s1A44   JSR s18E4
        LDA #>p0A00
        STA a03
        LDA #<p0A00
        STA a02
        TAX 
        LDA #$07
        STA a05
b1A54   LDA f1A9E,X
        AND #$3F
        ORA #$80
        STA a04
        JSR s1056
        INC a02
        INX 
        CPX #$16
        BNE b1A54
        JSR s1A24
        LDA #$30
        CLC 
        ADC a29
        STA a1EF1
b1A72   LDX #$30
b1A74   LDA fC000,X
        ORA #$80
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$03
        STA a0A
        LDY #$00
b1A82   DEY 
        BNE b1A82
        DEC a0A
        BNE b1A82
        DEX 
        BNE b1A74
        DEC VICCRE   ;$900E - sound volume
        BNE b1A72
        LDA #$00
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        JMP s18E4

f1A9E   .TEXT "AT LEVEL 00   LLAMAS:0"
j1AB4   LDX #$F8
        TXS 
        JSR s1B34
        JSR s18E4
        LDA #>p0A07
        STA a03
        LDA #<p0A07
        STA a02
        LDX #$00
b1AC7   LDA f1B05,X
        AND #$3F
        ORA #$80
        STA a04
        LDA #$03
        STA a05
        JSR s1056
        INC a02
        INX 
        CPX #$09
        BNE b1AC7
b1ADE   LDA #$80
        STA a0A
b1AE2   LDA a0A
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
b1AE7   LDY #$08
b1AE9   DEY 
        BNE b1AE9
        INC VICCRA   ;$900A - frequency of sound osc.1 (bass)
        BNE b1AE7
        INC a0A
        BNE b1AE2
        DEC VICCRE   ;$900E - sound volume
        BNE b1ADE
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        JSR s18E4
        JMP j1120

f1B05   .TEXT "GAME OVER"
s1B0E   LDA #$30
        STA a1FEF
        STA a1FF0
        LDA a25
        STA a0E
        BNE b1B1D
        RTS 

b1B1D   INC a1FF0
        LDA a1FF0
        CMP #$3A
        BNE b1B2F
        LDA #$30
        STA a1FF0
        INC a1FEF
b1B2F   DEC a0E
        BNE b1B1D
        RTS 

s1B34   LDX #$01
b1B36   LDA f1FCD,X
        CMP f1FDC,X
        BMI b1B48
        BEQ b1B43
        JMP j1B49

b1B43   INX 
        CPX #$08
        BNE b1B36
b1B48   RTS 

j1B49   LDX #$07
b1B4B   LDA f1FCD,X
        STA f1FDC,X
        DEX 
        BNE b1B4B
        RTS 

j1B55   LDA #$C2
        STA RAM_CINV
        LDA #$80
        STA a0291
        LDA #$02
        STA VIA1IER  ;$911E - interrupt enable register (IER)
        JMP j108E

        RTS 

        .BYTE $48,$98,$48,$8D,$02,$09,$8A,$8D
j1B70   STA VICCRF   ;$900F - screen colors: background, border & inverse
        JMP s18E4

        .BYTE $8D,$04
.include "charset.asm"
        .BYTE $00
