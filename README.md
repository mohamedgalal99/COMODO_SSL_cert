# COMODO_SSL_cert


This used to update ays nginx server ssl certificate

we used COMODO cert

(*) To make right chain append files is this order

    demo.MY-DOMAIN.crt
    COMODORSADomainValidationSecureServerCA.crt 
    COMODORSAAddTrustCA.crt 
    AddTrustExternalCARoot.crt
