; Copyright (c) 1993, TC-Products, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.
;+
; NAME:
;       CrossCor
;
; PURPOSE:
;       Diese Prozedur berechnet die Kreuzkorrelation zwischen zwei Kanälen im Zeitbereich.
;       Es kann zwischen verschiedenen Normierungen gewählt werden.
;       1. Normierung auf Anzahl der Datenpunkte
;       2. Normierung auf jeweiligen Überlapp
;       Um den Überlapp zwischen Signal x und y für alle Verschiebungen konstant zu halten
;       gibt es die Option unterschiedlich lange Signale zu korrelieren. D.h. Signal x wurde
;       im Zeitbereich größer gefenstert (um PShift nach links(-) und rechts(+)) als Signal y.
;
; CATEGORY:
;       Stat
;
; CALLING SEQUENCE:
;       Cxy = CrossCor(x,y,PShift [,CorrBranch=Branch] [,OverlapNorm=ONorm] [, Covar=Covar])
;
; INPUTS:
;       x      - FltArr(N)
;       y      - FltArr(M)
;       PShift - Anzahl der Punkte, um die die beiden Signale (x,y) maximal gegeneinander
;                verschoben werden sollen (Korrelationsintervall)
;       N=M          - "Auffüllen mit Nullen" bzw. varierender Überlapp
;       N=M+2*PShift - konstanter Überlapp
;
; KEYWORD PARAMETERS:
;       CorrBranch  - '+'/'-' mit dieser Option erhält man als Ergebnis nur den
;                     positiven bzw. negativen Zweig der Korrelation
;       OverlapNorm - wenn dieses Keyword gesetzt wurde wird auf den jeweiligen Überlapp der
;                     Verschiebung normiert. (Große Verschiebung - kleiner Überlapp)
;                     und es bedeutet, das gleichzeitig die Covarianz berechnet wird
;       Covar       - berechnet die Korvarianz
;
; OUTPUTS:
;       Cxy - Kreuzkorrelation zwischen Signal x und y.
;             ein Peak im positiven Ast der Korrelation bedeutet: Event auf x
;             liegt vor Event auf y (x vor y)
;
; RESTRICTIONS:
;       Die Anzahl der Datenpunkte in Signal x und y müssen übereinstimmen oder
;       der Term N_Elements(x)-N_Elements(y) EQ (2*PShift) muß TRUE ergeben.
;
; EXAMPLE:
;       SamplingFreq = 500.0    ; Hz
;       DataVec = FIndgen(250)
;       Freq01 = 20.0           ; Hz
;       x = cos(2*!Pi*(Freq01/SamplingFreq)*DataVec)
;       y = sin(2*!Pi*(Freq01/SamplingFreq)*DataVec)
;       PShift = 2*(SamplingFreq/Freq01)               ; 2 Perioden
;
;       Cxy = CrossCor(x, y, PShift, CorrBranch='-', /OverlapNorm)
;       plot, DataVec(0:PShift)*1e03/SamplingFreq, Cxy, xTitle='time / ms'
;
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.6  1998/01/28 09:52:12  saam
;             documentation for keyword COVAR
;
;       Revision 1.5  1997/12/16 13:49:18  saam
;             no comment
;
;       Revision 1.4  1997/12/16 10:59:11  saam
;             wieder ein Bug im Header
;
;       Revision 1.3  1997/12/16 10:50:49  saam
;             Header korrigiert & Main entfernt
;
;       Revision 1.2  1997/10/31 17:27:29  saam
;             Umwandlung in Funktion
;
;
;       Written by:     Thomas Wölbern, 23.09.94
;-
FUNCTION CrossCor,x,y,PShift,CorrBranch=Branch,OverlapNorm=ONorm,Covariance=Covar

   Default, Branch, 0
   Default, ONorm, 0
   Default, Covar, 0

   Mean_x = Total(x)/N_Elements(x)
   Mean_y = Total(y)/N_Elements(y)
   
   x = x - Mean_x
   y = y - Mean_y
   PNorm = SQRT(Total(x^2)*Total(y^2))
   
   
   IF Keyword_Set(Branch) THEN BEGIN
      Case Branch OF
         '+' : BEGIN
            CxyPlus  = FltArr(PShift+1)
            IF N_Elements(y) EQ N_Elements(x) THEN BEGIN
               AnzahlPunkte = N_Elements(y)
               IF Keyword_Set(ONorm) THEN BEGIN
                  For i=0,PShift DO BEGIN
                     CxyPlus(i)  = Total(x(0:AnzahlPunkte-1-i)*y(i:*)) / (AnzahlPunkte-i)
                  ENDFOR
               ENDIF ELSE BEGIN
                  For i=0,PShift DO BEGIN
                     CxyPlus(i)  = Total(x(0:AnzahlPunkte-1-i)*y(i:*))
                  ENDFOR
                  IF Keyword_Set(Covar) THEN CxyPlus=CxyPlus/AnzahlPunkte ELSE CxyPlus=CxyPlus/PNorm
               ENDELSE
            ENDIF ELSE BEGIN
               AnzahlPunkte_y = N_Elements(y)
               AnzahlPunkte_x = N_Elements(x)
               IF (AnzahlPunkte_x-AnzahlPunkte_y) EQ (2*PShift) THEN BEGIN
                  For i=0,PShift DO BEGIN
                     CxyPlus(i)  = Total(x(PShift-i:PShift-i+AnzahlPunkte_y-1)*y(*))
                  ENDFOR
                  IF Keyword_Set(Covar) THEN CxyPlus=CxyPlus/AnzahlPunkte_y ELSE CxyPlus=CxyPlus/PNorm
               ENDIF
            ENDELSE
            Cxy=CxyPlus
         END
         '-' : BEGIN
            CxyMinus = FltArr(PShift+1)
            IF N_Elements(y) EQ N_Elements(x) THEN BEGIN
               AnzahlPunkte = N_Elements(y)
               IF Keyword_Set(ONorm) THEN BEGIN
                  For i=0,PShift DO BEGIN
                     CxyMinus(i) = Total(x(i:*)*y(0:AnzahlPunkte-1-i)) / (AnzahlPunkte-i)
                  ENDFOR
               ENDIF ELSE BEGIN
                  For i=0,PShift DO BEGIN
                     CxyMinus(i) = Total(x(i:*)*y(0:AnzahlPunkte-1-i))
                  ENDFOR
                  IF Keyword_Set(Covar) THEN CxyMinus=CxyMinus/AnzahlPunkte ELSE CxyMinus=CxyMinus/PNorm
               ENDELSE
            ENDIF ELSE BEGIN
               AnzahlPunkte_y = N_Elements(y)
               AnzahlPunkte_x = N_Elements(x)
               IF (AnzahlPunkte_x-AnzahlPunkte_y) EQ (2*PShift) THEN BEGIN
                  For i=0,PShift DO BEGIN
                     CxyMinus(i) = Total(x(PShift+i:PShift+i+AnzahlPunkte_y-1)*y(*))
                  ENDFOR
                  IF Keyword_Set(Covar) THEN CxyMinus=CxyMinus/AnzahlPunkte_y ELSE CxyMinus=CxyMinus/PNorm
               ENDIF
            ENDELSE
            Cxy=CxyMinus
         END
      ENDCASE
   ENDIF ELSE BEGIN
      CxyMinus = FltArr(PShift+1)
      CxyPlus  = FltArr(PShift+1)
      
      IF N_Elements(y) EQ N_Elements(x) THEN BEGIN
         AnzahlPunkte = N_Elements(y)
         IF Keyword_Set(ONorm) THEN BEGIN
            For i=0,PShift DO BEGIN
               CxyMinus(i) = Total(x(i:*)*y(0:AnzahlPunkte-1-i)) / (AnzahlPunkte-i)
               CxyPlus(i)  = Total(x(0:AnzahlPunkte-1-i)*y(i:*)) / (AnzahlPunkte-i)
            ENDFOR
         ENDIF ELSE BEGIN
            For i=0,PShift DO BEGIN
               CxyMinus(i) = Total(x(i:*)*y(0:AnzahlPunkte-1-i))
               CxyPlus(i)  = Total(x(0:AnzahlPunkte-1-i)*y(i:*))
            ENDFOR
            IF Keyword_Set(Covar) THEN BEGIN
               CxyMinus=CxyMinus/AnzahlPunkte
               CxyPlus =CxyPlus /AnzahlPunkte
            ENDIF ELSE BEGIN
               CxyMinus=CxyMinus/PNorm
               CxyPlus =CxyPlus /PNorm
            ENDELSE
         ENDELSE
         Cxy = [Reverse(CxyMinus),CxyPlus(1:*)]
      ENDIF ELSE BEGIN
         AnzahlPunkte_y = N_Elements(y)
         AnzahlPunkte_x = N_Elements(x)
         IF (AnzahlPunkte_x-AnzahlPunkte_y) EQ (2*PShift) THEN BEGIN
            For i=0,PShift DO BEGIN
               CxyMinus(i) = Total(x(PShift+i:PShift+i+AnzahlPunkte_y-1)*y(*))
               CxyPlus(i)  = Total(x(PShift-i:PShift-i+AnzahlPunkte_y-1)*y(*))
            ENDFOR
            IF Keyword_Set(Covar) THEN BEGIN
               CxyMinus=CxyMinus/AnzahlPunkte_y
               CxyPlus =CxyPlus /AnzahlPunkte_y
            ENDIF ELSE BEGIN
               CxyMinus=CxyMinus/PNorm
               CxyPlus =CxyPlus /PNorm
            ENDELSE
            Cxy = [Reverse(CxyMinus),CxyPlus(1:*)]
         ENDIF
      ENDELSE
      
   ENDELSE
   
   RETURN, Cxy
END

;SamplingFreq = 500.0    ; Hz
;DataVec = FIndgen(25000)
;Freq01 = 20.0           ; Hz
;x = cos(2*!Pi*(Freq01/SamplingFreq)*DataVec)
;y = sin(2*!Pi*(Freq01/SamplingFreq)*DataVec)
;PShift = 2*(SamplingFreq/Freq01)               ; 2 Perioden

;;CrossCorrelation,x-(Total(x)/N_Elements(x)),y-(Total(y)/N_Elements(y)),PShift,Cxy,/Covariance;,CorrBranch='-',/OverlapNorm
;CrossCorrelation,x,y,PShift,Cxy,/Covariance;,CorrBranch='-',/OverlapNorm
;plot,(Findgen(2*PShift+1)-PShift)*1e03/SamplingFreq ,Cxy,xTitle='time / ms'

;Cxy = C_Correlate(x,y,Findgen(2*PShift+1)-PShift,/Covariance)
;plot,(Findgen(2*PShift+1)-PShift)*1e03/SamplingFreq,Cxy,Color=100
;end
