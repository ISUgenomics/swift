# swift
Swift bioinformatic scripts 


### Running on remote Linux machine 

Swift can be run using a singularity container. 


```
module load singularity
singularity pull docker://swift
singularity exec swift_latest.sif swift script
```

### Running on MacOS

All scriptName.swift files can be compiled to run on your local machine using the following command

```
swiftc -o scriptName -Osize script.swift
```
