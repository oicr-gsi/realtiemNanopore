# realtimeNanopore

Workflow to run Structural Variant caller

## Overview

## Dependencies

* [nvidia-docker2](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0))
* [NanoPlot](https://github.com/wdecoster/NanoPlot)


## Usage

### Cromwell
```
java -jar cromwell.jar run realtime-nanopore.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputPath`|String|Input directory (directory of the nanopore run)
`flowcell`|String|flowcell used in nanopore sequencing
`kit`|String|kit used in nanopore sequencing
`outputFileNamePrefix`|String|Variable used to set the name of the mergedfastqfile


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`guppyAdditionalParameters`|String?|None|Additional parameters to be added to the guppy command
`nanoplotAdditionalParameters`|String?|None|Additional parameters to be added to the nanoplot command


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`generateReports.guppy`|String|"guppy_basecaller"|guppy_basecaller name to use.
`generateReports.nanoplot`|String|"NanoPlot"|NanoPlot name to use
`generateReports.sequencingSummaryFilename`|String|"seqeuncing_summary.txt"|name of sequencing summary file
`generateReports.modules`|String|"guppy/3.2.4 nanoplot/1.27.0"|Environment module names and version to load (space separated) before command execution.
`generateReports.basecallingDevice`|String|'"cuda:0 cuda:1"'|Specify basecalling device: 'auto', or 'cuda:<device_id>'.
`generateReports.guppySavePath`|String|"guppy"|Path to save the guppy output
`generateReports.nanoplotSavePath`|String|"nanoplot"|Path to save the nanoplot output
`generateReports.memory`|Int|63|Memory (in GB) allocated for job.
`generateReports.numCallers`|Int|16|Number of parallel basecallers to create.
`generateReports.chunksPerRunner`|Int|3328|Maximum chunks per runner.


### Outputs

Output | Type | Description
---|---|---
`nanoplotReport`|File|None


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify -Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" -DrunTestThreads=2 -DskipITs=false -DskipRunITs=false -DworkingDirectory=/path/to/tmp/ -DschedulingHost=niassa_oozie_host -DwebserviceUrl=http://niassa-url:8080 -DwebserviceUser=niassa_user -DwebservicePassword=niassa_user_password -Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with wdl_doc_gen (https://github.com/oicr-gsi/wdl_doc_gen/)_
