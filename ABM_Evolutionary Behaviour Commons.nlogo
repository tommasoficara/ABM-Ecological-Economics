breed [cooperators cooperator]
breed [enforcers enforcer]
breed [defectors defector]
breed [fisheries fishery]

cooperators-own [payoff
effort default-color harvest]
defectors-own [payoff
effort harvest]
enforcers-own  [payoff
effort harvest]

globals [cum_h aggregated_h0 aggregated_h1 cum_e ]

to setup
  clear-all
setup_cum_h
create_cooperators
create_enforcers
create_defectors
create_fishery
setup_harvest
setup_patches
 set-default-shape cooperators "ship"
 set-default-shape enforcers "ship"
 set-default-shape defectors "ship"
 reset-ticks
end


to D_Equilibrium
  clear-all
  setup_cum_h
create_cooperators
create_enforcers
create_defectors
create_fishery
setup_harvest
setup_patches
  set size_fishery 1000
  set number_cooperators 8
  set number_defectors 8
  set number_enforcers 8
  set carrying_capacity 2000
  set growth_rate_fishery 0.21
  set sanction 0
  set cost_of_sanction 0
  set labour_cost 0.025
  set price 4
  reset-ticks
end

To C-E_Equilibrium1
  clear-all
   setup_cum_h
create_cooperators
create_enforcers
create_defectors
create_fishery
setup_harvest
setup_patches
  set size_fishery 1000
  set number_cooperators 8
  set number_defectors 8
  set number_enforcers 8
  set carrying_capacity 2000
  set growth_rate_fishery 0.21
  set sanction 30
  set cost_of_sanction 0
  set labour_cost 0.025
  set price 4
  reset-ticks
end

To C_Equilibrium
    clear-all
   setup_cum_h
create_cooperators
create_enforcers
create_defectors
create_fishery
setup_harvest
setup_patches
  set size_fishery 1000
  set number_cooperators 8
  set number_defectors 8
  set number_enforcers 8
  set carrying_capacity 2000
  set growth_rate_fishery 0.21
  set sanction 30
  set cost_of_sanction 0.6
  set labour_cost 0.025
  set price 4
  reset-ticks
end

To D_Equilibrium1
    clear-all
   setup_cum_h
create_cooperators
create_enforcers
create_defectors
create_fishery
setup_harvest
setup_patches
  set size_fishery 1000
  set number_cooperators 8
  set number_defectors 8
  set number_enforcers 8
  set carrying_capacity 2000
  set growth_rate_fishery 0.21
  set sanction 30
  set cost_of_sanction 1.2
  set labour_cost 0.025
  set price 4
  reset-ticks
end


to-report Total_catch
report sum [harvest] of cooperators + sum [harvest] of enforcers + sum [harvest] of defectors
end


to setup_cum_h
 set cum_h 0
end


to setup_harvest
  ask cooperators [set harvest 0]
  ask enforcers [set harvest 0]
  ask defectors [set harvest 0]
end

to setup_patches
  ask patches [ set pcolor blue ]
end

to create_cooperators
  create-cooperators number_cooperators [ setxy random-xcor random-ycor ]
  ask cooperators [set color white]
  ask cooperators [set shape "ship"]
  ask cooperators [set size 2]
end

to create_defectors
  create-defectors number_defectors [ setxy random-xcor random-ycor ]
  ask defectors [set color black]
  ask defectors [set shape "ship"]
  ask defectors [set size 2]
end


to create_enforcers
  create-enforcers number_enforcers [ setxy random-xcor random-ycor ]
  ask enforcers [set color red]
  ask enforcers [set shape "ship"]
  ask enforcers [set size 2]

end


to create_fishery
  create-fisheries size_fishery [ setxy random-xcor random-ycor ]
  ask fisheries [set shape "fish"]
  ask fisheries [set color 86]
  ask fisheries [set size random (1) + 0.5]
end

to go

ag_0
effort_simulation
cumulated_e
harvest_enforcers
harvest_cooperators
harvest_defectors
cumulated_h
ag_1
move
payoff_change
create_fish
enf_to_coop
def_to_coop
coop_to_enf
def_to_enf
coop_to_def
enf_to_def
print_stats
if ticks >= max_ticks [stop]
tick
if abs change_fishery > count fisheries or count fisheries < 50 [print "###############        TRAGEDY!!!          ################"]
  if abs change_fishery > count fisheries or count fisheries < 50 [stop]
end


to ag_0
  set aggregated_h0 cum_h
end

;;;;;;;;; EFFORTS ;;;;;;;;;;;

to effort_simulation
  ask cooperators [set effort 31 - random 2]
  ask enforcers [set effort 31 - random 2]
  ask defectors [set effort 85 - random 4]
end

to-report avg_effort_def
  ifelse count defectors > 0 [report sum [effort] of defectors / count defectors][report 0]
end

to-report avg_effort_coop
  ifelse count cooperators > 0  [report sum [effort] of cooperators / count cooperators][report 0]
end

to-report avg_effort_enf
  ifelse count enforcers > 0 [report sum [effort] of enforcers / count enforcers][report 0]
end

to-report aggregated_effort
  report sum [effort] of cooperators + sum [effort] of enforcers + sum [effort] of defectors
end

to harvest_cooperators
  ask cooperators [set harvest harvest + (10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)]
end

to harvest_enforcers
  ask enforcers [set harvest harvest + (10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)]
end

to harvest_defectors
  ask defectors [set harvest harvest + (10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)]
end

to cumulated_h
  set cum_h sum [harvest] of cooperators + sum [harvest] of enforcers + sum [harvest] of defectors
end

to cumulated_e
  set cum_e cum_e + aggregated_effort
end

to ag_1
set aggregated_h1 cum_h
end

to-report aggregated_harvest
  report aggregated_h1 - aggregated_h0
end


to-report total_agents
  report count cooperators + count defectors +  count enforcers
end


to-report share_cooperators
  ifelse total_agents != 0 [report count cooperators / (total_agents)] [report 0]
end


to-report share_defectors
  ifelse total_agents != 0 [report count defectors / (total_agents)] [report 0]
end


to-report share_enforcers
  ifelse total_agents != 0 [report count enforcers / (total_agents)] [report 0]
end

to-report t_payoff_coop
  report (price * (10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)) - labour_cost * effort
end

to-report t_payoff_enf
  ifelse count enforcers > 0 [report  (price * (10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)) - labour_cost * effort - ((count defectors / count enforcers) * cost_of_sanction)][report 0]
end

to-report t_payoff_def
  ifelse count enforcers > 0 [report  (price * (10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)) - labour_cost * effort - sanction][ifelse aggregated_effort > 0 [report  (price * ( 10 * (effort - 0.008 * effort ^ 2 ) * (count fisheries / carrying_capacity )) * (effort / aggregated_effort)) - labour_cost * effort][report 0]]
end

to payoff_change
  ask cooperators [set payoff payoff + t_payoff_coop]
  ask defectors [set payoff payoff + t_payoff_def]
  ask enforcers [set payoff payoff + t_payoff_enf]
end

to-report average_effort
  ifelse total_agents > 0 [report (share_enforcers * sum [payoff] of enforcers + share_cooperators * sum [payoff] of cooperators + share_defectors * sum [payoff] of cooperators)/ total_agents][report 0]
end

to-report avg_payoff_coop
  ifelse count cooperators > 0  [report sum [t_payoff_coop] of cooperators / count cooperators] [report 0]
end

to-report avg_payoff_enf
  ifelse count enforcers > 0 [report sum [t_payoff_enf] of enforcers / count enforcers] [report 0]
end

to-report avg_payoff_def
  ifelse count defectors > 0 [report sum [t_payoff_def] of defectors / count defectors] [report 0]
end

to-report avg_payoff
  ifelse total_agents > 0 [report  (sum [t_payoff_def] of defectors + sum  [t_payoff_enf] of enforcers + sum [t_payoff_coop] of cooperators ) / total_agents][report 0]
end

to-report aggregated_payoff
 report  sum [payoff] of cooperators +  sum [payoff] of enforcers +  sum [payoff] of defectors
end

to-report change_share_ec
  report share_cooperators * (avg_payoff_coop - avg_payoff_enf)
end

to-report change_share_dc
  report share_cooperators * (avg_payoff_coop - avg_payoff_def)
end

to-report change_share_ce
 report share_enforcers * (avg_payoff_enf - avg_payoff_coop)
end

to-report change_share_de
 report share_enforcers * (avg_payoff_enf - avg_payoff_def)
end

to-report change_share_cd
report share_defectors * (avg_payoff_def - avg_payoff_coop)
end

to-report change_share_ed
report share_defectors * (avg_payoff_def - avg_payoff_enf)
end
;;;;

to enf_to_coop
 if change_share_ec >= 0
 [ifelse  abs (total_agents * change_share_ec) <= count enforcers
    [repeat round abs (total_agents * change_share_ec) [ ask n-of 1 enforcers [set breed cooperators]ask cooperators [set color white]]]
      [ask enforcers [set breed cooperators]ask cooperators [set color white]]]
end

to def_to_coop
 if change_share_dc >= 0
 [ifelse  abs (total_agents * change_share_dc) <= count defectors
    [repeat round abs (total_agents * change_share_dc)[ask n-of 1 defectors [set breed cooperators]ask cooperators [set color white]]]
      [ask defectors [set breed cooperators]ask cooperators [set color white]]]
end

to def_to_enf

 if change_share_de >= 0
   [ifelse  abs (total_agents * change_share_de) <= count defectors
      [repeat round abs (total_agents * change_share_de) [ask n-of 1 defectors [set breed enforcers]ask enforcers [set color red]]]
      [ask defectors [set breed enforcers]ask enforcers [set color red]]]
end

to coop_to_enf
 if change_share_ce >= 0
   [ifelse  abs (total_agents * change_share_ce) <= count cooperators
    [repeat round abs (total_agents * change_share_ce)[ask n-of 1 cooperators[set breed enforcers]ask enforcers [set color red]]]
    [ask cooperators [set breed enforcers]ask enforcers [set color red]]]
end

to enf_to_def
 if change_share_ed >= 0 and count enforcers > 0
 [ifelse  abs (total_agents * change_share_ed) <= count enforcers
    [repeat round abs (total_agents * change_share_ed)[ask n-of 1 enforcers [set breed defectors]ask defectors [set color black]]]
    [ask enforcers [set breed defectors]ask defectors [set color black]]]
end

to coop_to_def
if change_share_cd >= 0 and count cooperators > 0
 [ifelse  abs (total_agents * change_share_cd) <= count cooperators
    [repeat round abs (total_agents * change_share_cd)[ask n-of 1 cooperators [set breed defectors] ask defectors [set color black]]]
    [ask cooperators [set breed defectors]ask defectors [set color black]]]
end

;;;;;;

to print_stats

end

to print_alt
 print "########################"
  print ticks
  print "Natural growth fisheries:"
  print natural_growth_fisheries
  print "Aggregated_harvest:"
  print round aggregated_harvest
  print "Change-fishery:"
  print change_fishery
   print "    CD    "
  print change_share_cd
  print total_agents * change_share_cd
  print round (total_agents * change_share_cd)
  print "    CE    "
  print change_share_ce
  print total_agents * change_share_ce
  print round (total_agents * change_share_ce)
  print "   ED"
  print change_share_ed
  print total_agents * change_share_ed
  print round (total_agents * change_share_ed)
  print "   EC"
  print change_share_ec
  print total_agents * change_share_ec
  print round (total_agents * change_share_ec)
  print "    DC"
  print change_share_dc
  print total_agents * change_share_dc
  print round (total_agents * change_share_dc)
  print "    DE"
  print change_share_de
  print total_agents * change_share_de
  print round (total_agents * change_share_de)

    print [t_payoff_coop] of cooperators
  print [t_payoff_enf] of enforcers
  print [t_payoff_def] of defectors
  print "    CD    "
  print change_share_cd
  print total_agents * change_share_cd
  print round (total_agents * change_share_cd)
  print "    CE    "
  print change_share_ce
  print total_agents * change_share_ce
  print round (total_agents * change_share_ce)
  print "   ED"
  print change_share_ed
  print total_agents * change_share_ed
  print round (total_agents * change_share_ed)
  print "   EC"
  print change_share_ec
  print total_agents * change_share_ec
  print round (total_agents * change_share_ec)
  print "    DC"
  print change_share_dc
  print total_agents * change_share_dc
  print round (total_agents * change_share_dc)
  print "    DE"
  print change_share_de
  print total_agents * change_share_de
  print round (total_agents * change_share_de)
  print "            "
  print "Count fish:"
  print count fisheries
  print "Natural growth fisheries:"
  print natural_growth_fisheries
  print "Change-fishery:"
  print change_fishery
  print "Aggregated_harvest:"
  print aggregated_harvest
  print  "aggregated_effort"
  print  aggregated_effort
  print "ticks: "print ticks
  print "Count fish:"
  print count fisheries
  print "Natural growth fisheries:"
  print natural_growth_fisheries
  print "Aggregated_harvest:"
  print aggregated_harvest
  print "Change-fishery:"
  print change_fishery
  print  "aggregated_effort"
  print  aggregated_effort
  print  "aggregated_harvest"
  print  aggregated_harvest
  print "aggregated_payoff"
  print aggregated_payoff
  print "labour_cost * aggregated_effort"
  print labour_cost * aggregated_effort
  print cum_h
  print aggregated_h0
  print "#############"
  print "#############"
  print "#############"
  print "Average Payoff coop"
  print avg_payoff_coop
  print "Average Payoff def"
  print avg_payoff_def
  print "Average Payoff enf"
  print avg_payoff_enf
  print "Average Payoff"
  print avg_payoff
  print average_effort
  print "Share of cooperators:"
  print precision share_cooperators 2
  print "Share of defectors:"
  print precision share_defectors 2
  print "Share of enforcers:"
  print precision share_enforcers 2
  print [t_payoff_coop] of cooperators
  print [t_payoff_enf] of enforcers
  print [t_payoff_def] of defectors
  print [payoff] of cooperators
  print [payoff] of enforcers
  print [payoff] of defectors
  print  "aggregated_effort"
  print  aggregated_effort
  print "            "
end

to-report catch-to-effort
  ifelse cum_e > 0 [ report total_catch / cum_e ][report 0]
end

to-report natural_growth_fisheries
 report round((growth_rate_fishery * count fisheries) * (1 - (count fisheries / carrying_capacity)))
end


to-report change_fishery
report round (natural_growth_fisheries - aggregated_harvest)
end

to create_fish
 ifelse change_fishery <= 0 and abs change_fishery <= count fisheries
  [    ask n-of abs change_fishery fisheries  [die]]

  [  create-fisheries change_fishery [ setxy random-xcor random-ycor ]
  ask fisheries [set shape "fish"]
  ask fisheries [set color 86]]
    ask fisheries [set size random (1 - 0.25) + 0.5]
end


to move
  ask cooperators [
    right random 360
    forward 1
  ]
  ask defectors [
     right random 360
    forward 1
  ]
  ask enforcers [
    right random 360
    forward 1
  ]
  ask fisheries [
    right random 360
    forward 0.5
  ]
end

to print_payoffs
  ask defectors [show payoff]
  ask cooperators [show payoff]
  ask enforcers [show payoff]
end

to tragedy
  if abs change_fishery > count fisheries [print "TRAGEDY!!!"]
end
@#$#@#$#@
GRAPHICS-WINDOW
400
10
626
237
-1
-1
6.61
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

SLIDER
660
32
832
65
number_cooperators
number_cooperators
0
30
8.0
1
1
NIL
HORIZONTAL

BUTTON
661
241
1025
279
Manual setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
660
115
832
148
number_defectors
number_defectors
0
50
8.0
1
1
NIL
HORIZONTAL

SLIDER
660
74
832
107
number_enforcers
number_enforcers
0
30
8.0
1
1
NIL
HORIZONTAL

BUTTON
257
332
386
446
GO
go 
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
849
32
1021
65
size_fishery
size_fishery
0
10000
1000.0
100
1
NIL
HORIZONTAL

SLIDER
850
74
1022
107
growth_rate_fishery
growth_rate_fishery
0
1
0.21
0.01
1
NIL
HORIZONTAL

MONITOR
401
241
625
302
Current Stock
count fisheries
17
1
15

MONITOR
1053
10
1167
55
Delta Payoff Coop
avg_payoff_coop
3
1
11

MONITOR
1053
60
1167
105
Delta Payoff Enf
precision avg_payoff_enf 2
3
1
11

MONITOR
1054
111
1167
156
Delta payoff Def
avg_payoff_def
3
1
11

MONITOR
1053
164
1165
209
Average Delta Payoff
avg_payoff
3
1
11

TEXTBOX
19
139
169
158
Enforcers : red\n
11
0.0
1

TEXTBOX
18
160
168
180
Defectors : black 
11
0.0
1

TEXTBOX
18
120
168
138
Cooperators : white
11
0.0
0

TEXTBOX
18
95
168
114
Color coding agents\n
15
0.0
1

PLOT
906
327
1206
462
Population overview
ticks
Count agents
0.0
50.0
0.0
60.0
true
true
"" ""
PENS
"Cooperators" 1.0 0 -5987164 true "" "plot count cooperators"
"Enforcers" 1.0 0 -5298144 true "" "plot count enforcers"
"Defectors" 1.0 0 -16777216 true "" "plot count defectors"

PLOT
402
324
625
460
Resource Stock
ticks
count fishery 
0.0
100.0
0.0
2000.0
true
false
"" ""
PENS
"fishery size" 1.0 0 -16777216 true "" "plot count fisheries"

MONITOR
297
158
364
203
Defectors
count defectors
17
1
11

MONITOR
296
32
363
77
Cooperators
count cooperators
17
1
11

MONITOR
297
95
363
140
Enforcers
Count enforcers
17
1
11

SLIDER
852
155
1024
188
sanction
sanction
0
80
30.0
0.1
1
NIL
HORIZONTAL

SLIDER
852
195
1024
228
cost_of_sanction
cost_of_sanction
0
2
1.2
0.1
1
NIL
HORIZONTAL

SLIDER
9
29
181
62
max_ticks
max_ticks
0
200
200.0
1
1
NIL
HORIZONTAL

MONITOR
8
231
113
288
Total harvest
round Total_catch
17
1
14

MONITOR
1054
210
1166
255
Ag.Harvest/tick
round aggregated_harvest
17
1
11

SLIDER
660
195
832
228
price
price
0
100
4.0
1
1
NIL
HORIZONTAL

MONITOR
135
231
240
288
catch-to-effort
precision catch-to-effort 2
17
1
14

BUTTON
5
310
244
343
S1: D_Equilibrium 
D_Equilibrium 
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
851
115
1023
148
carrying_capacity
carrying_capacity
0
3000
2000.0
100
1
NIL
HORIZONTAL

SLIDER
660
154
832
187
labour_cost
labour_cost
0
0.10
0.025
0.001
1
NIL
HORIZONTAL

BUTTON
5
349
244
382
S2: C-E_Equilibrium (no sanction costs)
C-E_Equilibrium1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
653
326
881
461
catch-to-effort
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot 100 * catch-to-effort"

MONITOR
260
231
364
288
Total payoff
round aggregated_payoff
17
1
14

BUTTON
5
388
244
425
S3: C_Equilibrium (low sanction costs)
C_Equilibrium
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
4
430
244
469
S4:  D_Equilibrium (high sanctions costs) 
D_Equilibrium1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

The simulation conducted through agent-based modelling (ABM) analyses the tragedy of commons dilemma, by shaping the open access good as a dynamic resource-stock and allowing the agents to evolve with respect to their extraction behaviour. 

## HOW IT WORKS

By setting diffent parameter values of sanctions (that affect defectors) and costs of sanctions (that affect defectors) the agents will change behaviour. It is possible also to assess logistic growth of the resource stock.

## HOW TO USE IT

Click on the preset Scenarios buttons on the bottom-left of the interface and then run "Go". 
Alternatively change manually parameters value and click "Manual Setup". Then click "Go".
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

ship
false
0
Polygon -7500403 true true 15 135 75 240 255 240 270 135 15 135
Rectangle -7500403 true true 120 90 225 135
Rectangle -7500403 true true 150 75 210 105
Rectangle -7500403 true true 180 30 195 120

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
