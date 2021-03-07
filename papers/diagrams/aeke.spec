A-EKE
Client <-> Server

\DHexpclient \Rchoose 1,...,N
\DHvalclient = \Generator^{\DHexpclient}
E_{\DHvalclient} = \Enc{\Hash{\Password}}{\DHvalclient}

-> \Identity, E_{\DHvalclient}

\DHexpserver \Rchoose 1,...,N
\DHvalserver = \Generator^{\DHexpserver}
E_{\DHvalserver} = \Enc{\Verifier}{\DHvalserver}
\Challenge_S \Rchoose \{0, 1\}^*
\DHvalclient = \Dec{\Password}{E_{\DHvalclient}}
\Key = \Keyfunc(\DHvalclient^{\DHexpserver})
E_{\Challenge_S} = \Enc{\Key}{\Challenge_S}

<- E_{\DHvalserver}, E_{\Challenge_S}

\DHvalserver = \Dec{\Password}{E_{\DHvalserver}}
\Key = \Keyfunc(\DHvalserver^{\DHexpclient})
\Challenge_C \Rchoose \{0, 1\}^*
\Challenge_S = \Dec{\Key}{E_{\Challenge_S}}
E_{\Challenge_{CS}} = \Enc{\Key}{\Challenge_C, \Challenge_S}

-> E_{\Challenge_{CS}}

\Challenge_C, \Challenge_S^* = \Dec{\Key}{E_{\Challenge_{CS}}}
\Challenge_S \Testeq \Challenge_S^*
E_{\Challenge_C} = \Enc{\Key}{\Challenge_C}

<- E_{\Challenge_C}

\Challenge_C^* = \Dec{\Key}{E_{\Challenge_C}}
\Challenge_C \Testeq \Challenge_C^*
E_{F_{\Password\Key}} = \Enc{\Key}{F(\Password,\Key)}

-> \E_{F_{\Password\Key}}

F_{PK} = \Dec{\Key}{E_{F_{\Password\Key}}}
\textrm{Test } T(\Verifier, F_{\Password\Key}, \Key) = \textrm{True}


