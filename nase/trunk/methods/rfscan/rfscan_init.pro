;+
; NAME: RFScan_Init()
;
; AIM:     initializes the RF-Cinematogramm of simulated neurons
;
; PURPOSE: Experimentelle Bestimmung der rezeptiven Felder der
;          Neuronen eines Layers unter bestimmten Reizbedingungen.
;          Die RFScan-Routinen sind der Methode des RF-Cinematogramms
;          nachempfunden, und können immer dann angewandt werden, wenn 
;          das RF der untersuchten Neuronen nicht direkt bestimmt
;          werden kann (beispielsweise, wenn der Signalfluß über
;          mehrere Layer geht oder Rückkopplung und Linking mit
;          einfließt, also nichtklassiche RFs vorliegen).
;
;   Beschreibung
;   der Methode: Die Routinen können in jede funktionierende
;                NASE-Simulation eingebaut werden:
;                Nach der Initialisierung mit RFScan_Init() erzeugt
;                die Funktion RFScan_Zeigmal() ein geeignetes
;                Inputmuster für den Eingabelayer des Netzwerks.
;                Dieses wird dann (wie im normalen Simulationsbetrieb) 
;                dem Netz präsentiert, die ganze Simulation wie immer
;                durchgenudelt, und dann, wenn man meint, dass das
;                Netz sich auf den Input eingestellt hat (er kann auch 
;                über mehrere Simulationsschritte hin präsentiert
;                werden), dann übergibt man einfach den Output der zu
;                untersuchenden Neuronen an die Routine
;                RFScan_Schaumal. (Auch das kann für ein gegebenes
;                Muster mehrfach geschehen.)
;                Danach besorgt man sich ein neues Inputbild mit
;                RFScan_Zeigmal() usw.
;                Aus der Abhängigkeit von Input- und Outputmuster wird 
;                dann eine Schätzung für das (effektive) rezeptive
;                Feld der Neuronen berechnet, die man sich zum Schluß
;                mit RFScan_Return() als DW-Struktur zurückgeben läßt.
;
;
; CATEGORY: Auswertung, Analyse, Statistik, Methoden
;
; CALLING SEQUENCE: My_RFScan = RFScan_Init( [  Picture ]
;                                            { ,INDW=EingabeDWStruktur | ,WIDTH=Bildbreite, HEIGHT=Bildhöhe }
;                                              ,OUTLAYER=AusgabeLayer
;                                            [,/SHIFT_VERTICAL ]
;                                            [,/SHIFT_HORIZONTAL ]
;                                            [,/AUTO_SINGLEDOT
;                                             |,AUTO_RANDOMDOTS=PunktHäufigkeit
;                                             |,AUTO_VERTICALLINE=Linienbreite | ,AUTO_HORIZONTALLINE=Linienbreite
;                                             |,AUTO_VERTICALEDGE={-2|-1|1|2|3} | ,AUTO_HORIZONTALEDGE={-2|-1|1|2|3}
;                                            ]
;                                            [,/OBSERVE_SPIKES | ,/OBSERVE_POTENTIALS ]
;                                            [,VISUALIZE=Array(InZoom,OutZoom,DWZoom,Period) [,/WRAP] ] )
;
; INPUTS: INDW | WIDTH, HEIGHT:
;                   Die DW-Struktur, als deren Input ein Bild generiert werden
;                   soll. Für den Fall, daß die Verarbeitung des Bildes 
;                   nicht direkt über DelayWeigh
;                   geschieht, sondern beispielsweise über eine
;                   mathematische Operation (Faltung), kann alternativ
;                   auch direkt Bildbreite und -höhe in WIDTH und
;                   HEIGHT übergeben werden.
;         OUTLAYER: Der Layer, für dessen Neuronen die RFs bestimmt
;                   werden sollen.
;
; OPTIONAL INPUTS & KEYWORD PARAMETERS:
;
;         VISUALIZE: Ist dieses Schlüsselwort benutzt, wird der
;                    Scanvorgang in einem Fenster dargestellt.
;                    In VISUALIZE muß dazu ein vierelementiges
;                    IntegerArray übergeben werden (s. CALLING
;                    SEQUENCE), dessen Elemente folgende Bedutung
;                    haben:
;                    InZoom:  Zoomfaktor für die Darstellung des Inputs
;                    OutZoom:      "      "   "        "      "  Outputs
;                    DWZoom:       "      "   "        "      der DW-Matrix mit ShowWeights
;                    Period:  Intervalle, in denen die Bildschirmdarstellung aufgefrischt wird
;                             (d.h.: alle soundsoviel Aufrufe von RFScan_Schaumal wird die DW-Matrix neu dargestellt.)
;
;              WRAP: Hat nur in Verbindung mit VISUALIZE Bedeutung. Es
;                    wird direkt an die MiddleWieghts-Routine
;                    übergeben, der es mitteilt, ob zyklische
;                    Randbedingungen bei der DW-Matrix angenommen
;                    werden sollen, oder nicht.
;
;         OBSERVE_SPIKES | OBSERVE_POTENTIALS:
;                    Das Setzen eines dieser Schlüsselworte
;                    entscheidet darüber, welche Information des
;                    OutputLayers zur Berechnung der RFs benutzt wird:
;                    Die reine Spike-Information (OBSERVE_SPIKES, dies 
;                    ist der Default) oder das Membranpotential
;                    (OBSERVE_POTENTIALS), also eine Art
;                    intrazelluläre Ableitung. Man beachte, daß das
;                    Spikemuster lediglich Auskunft darüber gibt, ob
;                    eine Zelle genügend erregt war, um zu
;                    feuern. Daher enthält das daraus berechnete RF
;                    natürlich keine negativen Anteile. Bei Auswertung 
;                    des Membranpotentials wird auch eine aktive
;                    Hemmung der Zelle (M < 0) erkannt. Die so
;                    bestimmten RFs können daher auch negative Anteile 
;                    enthalten.
;
;         Alle weiteren Schlüsselworte und das "Picture"-Argument
;         betreffen die Art des Inputs.
;         Dabei werden drei mögliche Inputmethoden unterschieden:
;
;         1. Die manuelle Methode: Wird keins der Input-Schlüsselworte 
;                                  angegeben und fehlt auch das
;                                  "Picture"-Argument, so muß bei
;                                  jedem folgenden Aufruf von
;                                  RFScan_Zeigmal() das zu
;                                  präsentierende Bild manuell
;                                  spezifiziert werden. Dieser Modus
;                                  erlaubt dem Benutzer die völlige
;                                  Kontrolle über die Art de Inputs.
;                                  Wird der RF-Scan mit der manuellen
;                                  Methode initialisiert, so wird eine 
;                                  informative Message darüber
;                                  ausgegeben.
;         2. Die halbautomatische
;                         Methode: Wird bei der Initialisierung ein
;                                  Bild als "Picture"-Argument
;                                  übergeben (auf richtige Ausmaße
;                                  achten!), so sorgt RFScan_Zeigmal
;                                  automatisch dafür, daß dieses Bild
;                                  bei jedem Aufruf geeignet
;                                  verschoben wird. Dabei entscheiden
;                                  die Schlüsselworte SHIFT_VERTICAL
;                                  und SHIFT_HORIZONTAL darüber, ob
;                                  das Bild vertikal, horizontal oder
;                                  in beiden Richtungen verschoben
;                                  werden soll (dazu können entweder
;                                  beide oder keines der
;                                  SHIFT-Schlüsselworte angegeben
;                                  werden.) RFScan_Zeigmal()
;                                  präsentiert das Bild zufällig an
;                                  allen möglichen Positionen und
;                                  informiert darüber, wenn ein neuer
;                                  Präsentationszyklus beginnt.
;         3. Die vollautomatische
;                         Methode: Wird eines der AUTO-Schlüsselworte
;                                  angegeben, so generiert
;                                  RFScan_Zeigmal() den Input
;                                  automatisch.
;                                  Es braucht kein "Picture"-Argument
;                                  übergeben zu werden.
;            Die AUTO-Modi:
;                  AUTO_SINGLEDOT: Als Input wird ein einzelner Pixel
;                                  generiert, der gleichverteilt
;                                  zufällig an jeder Position des
;                                  Inputarrays erscheinen kann.
;                 AUTO_RANDOMDOTS: Als Input wird ein zufälliges
;                                  Punktmuster generiert. Der Wert
;                                  dieses Schlüsselwortes entscheidet
;                                  dabei über die Häufigkeit der
;                                  Punkte. (Ein Wert von 0.5 bedeutet
;                                  gleichviele dunkle wie helle
;                                  Stellen.)
;               AUTO_VERTICALLINE: Als Input dient eine vertikale
;                                  Linie, die an allen möglichen
;                                  horizontalen Positionen präsentiert 
;                                  wird. Der Wert des Schlüsselwortes
;                                  entscheidet dabei über die Dicke
;                                  der Linie. (In Pixeln)
;             AUTO_HORIZONTALLINE: entsprechend.
;               AUTO_VERTICALEDGE: Als Input dient eine (oder zwei, 
;                                  s.u.) vertikale
;                                  Kontrastkanten, die an allen
;                                  möglichen horizontalen Positionen
;                                  präsentiert werden. Der Wert des
;                                  Schlüsselwortes entscheidet
;                                  darüber, ob (Typ 1) ein
;                                  Hell-/Dunkel-Übergang oder (Typ 2)
;                                  ein Dunkel-/Hell-Übergang
;                                  oder (Typ 3) jeweils zwei Übergänge 
;                                  (Hell-/Dunkel- und Dunkel-/Hell-)
;                                  generiert werden.
;                                  Oder: (Typ -1) ein scharfer
;                                        Hell-/Dunkel-Übergang und ein 
;                                        verwaschener
;                                        Dunkel-/Hell-Übergang oder
;                                        (Typ -2) ein scharfer
;                                        Dunkel-/Hell-Übergang und ein 
;                                        verwaschener
;                                        Hell-/Dunkel-Übergang.
;                                  Anbei: Die Inputtypen 1 und 2 sind für
;                                         Netze mit zyklischen
;                                         Randbedingugen nur
;                                         beschränkt geeignet, weil
;                                         dann an Position 0 eine in
;                                         allen Bildern vorhandene
;                                         Kontrastkante des jeweils
;                                         anderen Typs vorliegt!
;                                         Dagegen sind die Inputtypen
;                                         -1 und -2 für zyklische
;                                         Netze besonders geeignet,
;                                         jedoch weiniger für nichtzyklische.
;                                  
;
; OUTPUTS: My_RFScan: Eine Struktur mit Info-Tag "RFSCAN", die alle
;                     nötigen Daten für die anderen RFScan-Routinen enthält.
;
; SIDE EFFECTS: Es wird dynamischer Speicher für eine DW-Struktur angefordert.
;
; RESTRICTIONS: Man beachte, daß die erhaltenen Ergebnisse stark vom
;               gewählten Inputtyp abhängen! Z.B. kann keine
;               Erkenntnis über horizontale Komponenten eines RFs
;               erwartet werden, wenn mit einer vertikalen Linie
;               getestet wird!
;
; EXAMPLE: My_RFScan = RFScan_Init( INDW=XCells_Recept, OUTLAYER=SimpleCells, AUTO_RANDOMDOTS=0.5 )
;          Ich werd wohl ne BeispielSimulation zur Verfügung stellen...          
;
; SEE ALSO: <A HREF="#RFSCAN_ZEIGMAL">RFScan_Zeigmal()</A>, <A HREF="#RFSCAN_SCHAUMAL">RFScan_Schaumal</A>, <A HREF="#RFSCAN_RETURN">RFScan_Return()</A>
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.9  2000/09/28 12:25:17  gabriel
;             AIM tag added , message <> console
;
;        Revision 1.8  2000/06/16 08:53:01  kupper
;        Some corrections for AUTO_SINGLEDOT.
;        Adjusted header.
;
;        Revision 1.7  2000/06/16 08:28:32  kupper
;        Added AUTO_SINGLEDOT mode.
;
;        Revision 1.6  1998/03/14 11:26:46  kupper
;               Inputkantentypen -1 und -2 implementiert.
;               Kosmetische Änderung an der Visualisierung (dreheung des Surface Plots).
;
;        Revision 1.5  1998/03/06 11:35:10  kupper
;               Bug korrigiert, der bei IDL-Versionen kleiner 5 auftrat,
;                wenn beim Aufruf kein Fenster geöffnet war.
;
;        Revision 1.4  1998/03/03 14:44:20  kupper
;               RFScan_Schaumal ist jetzt viel schneller, weil es
;                1. direkt auf den Weights-Tag der (Oldstyle)-DW-Struktur zugreift.
;                   Das ist zwar unelegant, aber schnell.
;                2. Beim Spikes-Observieren von den SSParse-Listenm Gebrauch
;                   macht und daher nur für die tatsächlich feuernden Neuronen
;                   Berechnungen durchführt.
;
;        Revision 1.3  1998/02/16 14:59:47  kupper
;               VISUALIZE ist jetzt implementiert. WRAP auch.
;
;        Revision 1.4  1998/02/10 14:21:58  kupper
;               kleiner Übergangs-Commit...
;
;        Revision 1.3  1998/02/09 18:18:09  kupper
;               Noch dabei, VISUALIZE zu implementieren.
;                Mußte schonmal einchecken, wegen NASE-Umzug auf Neuro...
;
;        Revision 1.2  1998/01/30 17:02:48  kupper
;               Header geschrieben und kosmetische Veränderungen.
;                 VISUALIZE ist noch immer nicht implementiert.
;
;        Revision 1.1  1998/01/29 14:45:05  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;

Function RFScan_Init, INDW=InDW, OUTLAYER=OutLayer, Picture, $
               WIDTH=width, HEIGHT=height, $
               AUTO_SINGLEDOT=auto_singledot, $
               AUTO_RANDOMDOTS=auto_randomdots, $
               AUTO_VERTICALEDGE=auto_verticaledge, $
               AUTO_HORIZONTALEDGE=auto_horizontaledge, $
               AUTO_VERTICALLINE=auto_verticalline, $
               AUTO_HORIZONTALLINE=auto_horizontalline, $
               SHIFT_VERTICAL=shift_vertical, SHIFT_HORIZONTAL=shift_horizontal, $
               OBSERVE_SPIKES=observe_spikes, OBSERVE_POTENTIALS=observe_potentials, $
               VISUALIZE=visualize, WRAP=wrap

   If keyword_set(VISUALIZE) and n_elements(VISUALIZE) ne 4 then $
    console, /fatal, "Keyword VISUALIZE is expected to be set to a four-elementary Array!"

   If keyword_set(InDW) then begin
      WIDTH = DWDim(InDW, /SW)
      HEIGHT = DWDim(InDW, /SH)
   endif   

   ;;------------------> Implementation of AUTO-LINE-MODES:
   If keyword_set(AUTO_HORIZONTALLINE) then begin
      Picture = fltarr(HEIGHT, WIDTH)
      Picture(0:AUTO_HORIZONTALLINE-1, *) = 1.0
      SHIFT_VERTICAL = 1
      SHIFT_HORIZONTAL = 0
   Endif
   If keyword_set(AUTO_VERTICALLINE) then begin
      Picture = fltarr(HEIGHT, WIDTH)
      Picture(*, 0:AUTO_VERTICALLINE-1) = 1.0
      SHIFT_VERTICAL = 0
      SHIFT_HORIZONTAL = 1
   Endif
   ;;--------------------------------

   ;;------------------> Implementation of smooth AUTO-EDGE-MODES:
   If keyword_set(AUTO_HORIZONTALEDGE) then begin
      If AUTO_HORIZONTALEDGE le -1 then begin
         Picture = indgen(HEIGHT)/float(HEIGHT-1)
         If AUTO_HORIZONTALEDGE eq -2 then Picture = 1-Picture
         Picture = rebin(Picture, HEIGHT, WIDTH, /SAMPLE)
         SHIFT_VERTICAL = 1
         SHIFT_HORIZONTAL = 0
         AUTO_HORIZONTALEDGE = 0 ;Shift will do the job...
      Endif
   EndIf
   If keyword_set(AUTO_VERTICALEDGE) then begin
      If AUTO_VERTICALEDGE le -1 then begin
         Picture = transpose(indgen(WIDTH)/float(WIDTH-1))
         If AUTO_VERTICALEDGE eq -2 then Picture = 1-Picture
         Picture = rebin(Picture, HEIGHT, WIDTH, /SAMPLE)
         SHIFT_VERTICAL = 0
         SHIFT_HORIZONTAL = 1
         AUTO_VERTICALEDGE = 0  ;Shift will do the job...
      Endif
   Endif
   ;;--------------------------------

   ;;------------------> Will Picture be manually defined?
   MANUAL = not set(Picture) and not keyword_set(AUTO_SINGLEDOT) and not keyword_set(AUTO_RANDOMDOTS) and not keyword_set(AUTO_VERTICALEDGE) and not keyword_set(AUTO_HORIZONTALEDGE)
   If MANUAL then console, /MSG, "No Input Picture defined - will expect manual specification..."
   ;;--------------------------------

   ;;------------------> Will Picture be shifted in both directions?
   If (not keyword_set(SHIFT_VERTICAL) and not Keyword_Set(SHIFT_HORIZONTAL) ) OR $
    (keyword_set(SHIFT_VERTICAL) and Keyword_Set(SHIFT_HORIZONTAL) ) then begin
      SHIFT_BOTH = 1
      SHIFT_VERTICAL = 0
      SHIFT_HORIZONTAL = 0
                                ;From this point on, SHIFT_VERTICAL
                                ;and SHIFT_HORIZONTAL will mean "shift 
                                ;in this direction ONLY"
   EndIf
   ;;--------------------------------

   If Keyword_Set(SHIFT_BOTH) then shiftpositions = all_random(WIDTH*HEIGHT)
   If Keyword_Set(SHIFT_VERTICAL) then shiftpositions = all_random(HEIGHT)
   If Keyword_Set(SHIFT_HORIZONTAL) then shiftpositions = all_random(WIDTH)
   If Keyword_Set(AUTO_HORIZONTALEDGE) then begin
      shiftpositions = all_random(HEIGHT)
      If AUTO_HORIZONTALEDGE eq 3 then shiftpositions2 = all_random(HEIGHT)
   EndIf
   If Keyword_Set(AUTO_VERTICALEDGE) then begin
      shiftpositions = all_random(WIDTH)
      If AUTO_VERTICALEDGE eq 3 then shiftpositions2 = all_random(WIDTH)
   EndIf

   ;;------------------> The Default is to observe Spikes...
   If not Keyword_Set(OBSERVE_SPIKES) and not Keyword_Set(OBSERVE_POTENTIALS) then begin
      OBSERVE_SPIKES = 1
      OBSERVE_POTENTIALS = 0
   endif
   If Keyword_Set(OBSERVE_POTENTIALS) then OBSERVE_SPIKES = 0
   ;;--------------------------------

   ;;------------------> DW-Structure for estimated RFs:
   RFs = InitDW(S_WIDTH = WIDTH, S_HEIGHT=HEIGHT, T_LAYER=OUTLAYER, /OLDSTYLE)
   ;;using old style DW-Struct (not SDW) for faster Operation...
   ;;--------------------------------

      ;;------------------> VISUALIZE?
   If keyword_set(VISUALIZE) then begin
      ActWin = !D.Window
      
      window, /free, xpos=0, ypos=30, Title="RFScan - Presented Picture", xsize=WIDTH*VISUALIZE(0), ysize=HEIGHT*VISUALIZE(0)
      WinIn = !D.Window
      window, /free, xpos=WIDTH*VISUALIZE(0)+10, ypos=30, Title="RFScan - Observed Output", xsize=LayerWidth(OutLayer)*VISUALIZE(1), ysize=LayerHeight(OutLayer)*VISUALIZE(1)
      WinOut = !D.Window
      ShowWeights, RFs, /RECEPTIVE, Titel="RFScan - Estimated Receptive Fields", ZOOM=VISUALIZE(2), GET_WIN=WinRFs, GET_MAXCOL=MaxCol, GET_COLORMODE=ColorMode
      window, /free, Title="RFScan - Mean Estimated RF", xsize=300, ysize=300
      WinMean = !D.Window
      
      If ActWin ne -1 then WSet, ActWin
   End
   ;;--------------------------------

   ;;------------------> I want them all to be defined...
   Default, Picture, fltarr(HEIGHT, WIDTH)
   Default, AUTO_SINGLEDOT, 0
   Default, AUTO_RANDOMDOTS, 0
   Default, AUTO_VERTICALEDGE, 0
   Default, AUTO_HORIZONTALEDGE, 0
   Default, SHIFT_VERTICAL, 0
   Default, SHIFT_HORIZONTAL, 0
   Default, SHIFT_BOTH, 0
   Default, VISUALIZE, 0
   Default, shiftpositions, -1
   Default, shiftpositions2, -1
   Default, OBSERVE_SPIKES, 1
   Default, OBSERVE_POTENTIALS, 0
   Default, WinIn, -1
   Default, WinOut, -1
   Default, WinRFs, -1
   Default, WinMean, -1
   Default, MaxCol, -1
   Default, ColorMode, 0
   Default, WRAP, 0
   ;;--------------------------------


   Return, {info:                "RFSCAN", $
            width:               WIDTH, $
            height:              HEIGHT, $
            RFs:                 RFs, $
            original:            Picture, $
            picture:             fltarr(HEIGHT, WIDTH), $
            manual:              MANUAL, $
            auto_singledot :     AUTO_SINGLEDOT, $
            auto_randomdots:     AUTO_RANDOMDOTS, $
            auto_verticaledge:   AUTO_VERTICALEDGE, $
            auto_horizontaledge: AUTO_HORIZONTALEDGE, $
            shift_vertical:      SHIFT_VERTICAL, $
            shift_horizontal:    SHIFT_HORIZONTAL, $
            shift_both:          SHIFT_BOTH, $
            visualize:           VISUALIZE, $
            count:               0l, $ ;This will count the number of Input-Pictures
            divide:              0l, $ ;This will count the number of observed Outputs
            shiftpositions:      shiftpositions, $
            shiftpositions2:     shiftpositions2, $
            observe_spikes:      OBSERVE_SPIKES, $
            observe_potentials:  OBSERVE_POTENTIALS, $
            winin:               WinIn, $
            winout:              WinOut, $
            winRFs:              WinRFs, $
            winmean:             WinMean, $
            maxcol:              MaxCol, $
            colormode:           ColorMode, $
            wrap:                WRAP}
   
   
End
