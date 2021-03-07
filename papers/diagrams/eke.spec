EKE
Alice <-> Bob

\DHexpA \Rchoose 1,...,N
\DHvalA = \Generator^{x}
E_{\DHvalA} = \Encrypt{\Password}{\DHvalA}

-> \Identity, E_{\DHvalA}

\DHexpB \Rchoose 1,...,N
\DHvalB = \Generator^{\DHexpB}
E_{\DHvalB} = \Encrypt{\Password}{\DHvalB}
\DHvalA = \Decrypt{\Password}{E_{\DHvalA}}
\Key = \Keyfunc(\DHvalA^{\DHexpB})
\Challenge_B \Rchoose \{0,1\}^*
E_{\Challenge_B} = \Encrypt{K}{\Challenge_B}

<- E_{\DHvalB}, E_{\Challenge_B}

\DHvalB = \Decrypt{\Password}{E_{\DHvalB}}
\Key = \Keyfunc(\DHvalB^{\DHexpA})
\Challenge_B = \Decrypt{K}{E_{\Challenge_B}}
\Challenge_A \Rchoose \{0,1\}^*
E_{\Challenge_{AB}} = \Encrypt{K}{\Challenge_A, \Challenge_B}

-> E_{\Challenge_{AB}}

\Challenge_A, \Challenge_B^* = \Decrypt{K}{E_{\Challenge_{AB}}}
\Challenge_B =? \Challenge_B^*
E_{\Challenge_A} = \Encrypt{K}{\Challenge_A}

<- E_{\Challenge_A}

\Challenge_A^* = \Decrypt{K}{E_{\Challenge_A}}
\Challenge_A \Testeq  \Challenge_A^*



