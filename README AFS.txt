README AFS

Link this code: https://github.com/derson7es/AFS-Matlab-Wind-Turbine-Code.git


Matlab code designed to simulate onshore and offshore wind turbines and study 
problems related to effective wind speed control and estimation. The code is
 intended for academic purposes only.

The original version is the version used in the presentation of a master's
 thesis in naval and oceanic engineering at the University of São Paulo. The
 version is finalized for the purpose of this work. During development, several
 modules were added outside the scope of the work and served as support. Some
 of these were resolved in separate code and will be updated here.

There are some modules that need to be finalized or revised, as they were not 
the initial objective of the master's thesis. For example, the tower dynamics,
 the implementation of BEM theory, where an approach for a larger operating 
margin (Vop = 0.1 at 40 m/s) would be added, among others. It is up to the
 user to decide whether or not to take advantage of what is available.

Regarding the code architecture, it was a model presented in the course
 and handout "Numerical Methods Applied to Naval and Ocean Engineering" 
by Professor André Fujarra. Each Logical Instance would be a kind of 
Matlab "file function." However, it allows any other Logical Instance,
 including itself, to be called recursively. Another characteristic of 
the architecture is from a data perspective. The code may be ugly 
aesthetically, etc., but the end result is traceability. When something
 in the code goes wrong, I have input and output records for each 
"block," allowing me to handle large amounts of data for analysis and
 validation of the numerical simulation. The conventional way of 
passing variables and parameters in Matlab functions was also not
adopted; everything is placed in a "structure s" and designated 
as a global variable. This way, only the "s" variable is passed, 
and this way, any value or element of it can be called from any
function (Logical Instance). Since the code contained a lot of
data, the "structure who." defines the variable name and unit (if applicable).

That said, I'd like to comment that I believe this code can help
 undergraduate and graduate students, or those studying the topic
 at an early academic level. For more advanced users, validated
 tools and software are recommended.

A simple manual explaining how to use all the code options will be added soon.

The main objective of this code was to support the simulations performed in the
 work: 

Control of wind turbine based on effective wind speed estimation / A. F. da Silva -- versão corr. -- São Paulo, 2025.

Please use this example to cite this code:

SILVA, A. F. da. AFS Matlab Wind Turbine Code. [S.l.], 2025. Available at: GitHub. Available from Internet: <https://github.com/derson7es/AFS-Matlab-Wind-Turbine-Code.git>. Cited in page 42.

Or in latex language, it would be:

@techreport{silva2025afs,
  title        = {AFS Matlab Wind Turbine Code},
  author       = {da Silva, Anderson Francisco},
  institution  = {Department of Naval and Ocean Engineering, University of São Paulo},
  year         = {2025},
  url          = {https://github.com/derson7es/AFS-Matlab-Wind-Turbine-Code.git},
  note         = {Available at: GitHub}
}



This code and the concepts implemented within it should only be used for academic purposes. Commercial use or other non-academic purposes are not authorized by the author. If used academically, they will be properly cited.

It's important to note that the code uses theory from other works, including the dissertation developed with it. Therefore, when using any concept, please also cite the respective author.

Thank you for reading this far and enjoy using the code.

Jesus loves you!