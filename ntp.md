# check NTP

$ chronyc sources
$ chronyc tracking

```
chronyc sources
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
^+ ntp3.kashra-server.com        2  10   377   688  +2139us[+2576us] +/-   30ms
^+ ntp1.karneval.cz              2  10   377    47  +2581us[+2581us] +/-   22ms
^+ ntp44.kashra-server.com       2  10   377   664   -408us[  +29us] +/-   29ms
^* host189-248-2-81.serverd>     2  10   377   638  +4006us[+4443us] +/-   14ms
^x _gateway                     11   8   377   426   +26.2s[ +26.2s] +/-   15ms
```

M

* ^ means a server
* = means a peer 
* '#' indicates a locally connected reference clock.

S

* '*' indicates the best source which is currently selected for synchronisation.
* + indicates other sources selected for synchronisation, which are combined with the best source.
* - indicates a source which is considered to be selectable for synchronisation, but not currently selected.
* x indicates a source which chronyd thinks is a falseticker (i.e. its time is inconsistent with a majority of other sources, or sources specified with the trust option).
* ~ indicates a source whose time appears to have too much variability.
* ? indicates a source which is not considered to be selectable for synchronisation for other reasons (e.g.
*nreachable, not synchronised, or does not have enough measurements).
