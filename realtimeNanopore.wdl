version 1.0

workflow realtimeNanopore {
    input {
        String inputPath
        String flowcell
        String kit
        String outputFileNamePrefix
        String? guppyAdditionalParameters
        String? nanoplotAdditionalParameters
    }
    parameter_meta {
        inputPath: "Input directory (directory of the nanopore run)"
        flowcell: "flowcell used in nanopore sequencing"
        kit: "kit used in nanopore sequencing"
        outputFileNamePrefix: "Variable used to set the name of the mergedfastqfile"
        guppyAdditionalParameters: "Additional parameters to be added to the guppy command"
        nanoplotAdditionalParameters: "Additional parameters to be added to the nanoplot command"
    }

    meta {
        author: "Matthew Wong"
        email: "m2wong@oicr.on.ca"
        description: "Workflow to create realtime nanopore reports"
        dependencies: [{
            name: "nvidia-docker2",
            url: "https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)"
        },{
            name: "NanoPlot",
            url: "https://github.com/wdecoster/NanoPlot"
        }]
    }
    call generateReports {
        input:
            inputPath = inputPath,
            flowcell = flowcell,
            kit = kit,
            outputFileNamePrefix = outputFileNamePrefix,
            guppyAdditionalParameters = guppyAdditionalParameters,
            nanoplotAdditionalParameters = nanoplotAdditionalParameters
    }

    output {
        File nanoplotReport = generateReports.nanoplotReport
    }
}


task generateReports {
    input {
        String guppy = "guppy_basecaller"
        String nanoplot = "NanoPlot"
        String inputPath
        String flowcell
        String kit
        String sequencingSummaryFilename = "sequencing_summary.txt"
        String outputFileNamePrefix
        String modules = "guppy/3.2.4 nanoplot/1.27.0"
        String basecallingDevice = '"cuda:0 cuda:1"'
        String guppySavePath = "guppy"
        String nanoplotSavePath = "nanoplot"
        String? guppyAdditionalParameters
        String? nanoplotAdditionalParameters
        Int memory = 63
        Int numCallers = 16
        Int chunksPerRunner = 3328
    }
    parameter_meta {
        guppy: "guppy_basecaller name to use."
        nanoplot: "NanoPlot name to use"
        inputPath: "Input directory (directory of the nanopore run)"
        flowcell: "flowcell used in nanopore sequencing"
        kit: "kit used in nanopore sequencing"
        sequencingSummaryFilename: "name of sequencing summary file"
        guppySavePath: "Path to save the guppy output"
        nanoplotSavePath: "Path to save the nanoplot output"
        modules: "Environment module names and version to load (space separated) before command execution."
        basecallingDevice: "Specify basecalling device: 'auto', or 'cuda:<device_id>'."
        memory: "Memory (in GB) allocated for job."
        chunksPerRunner: "Maximum chunks per runner."
        numCallers: "Number of parallel basecallers to create."
        outputFileNamePrefix: "Variable used to set the name of the mergedfastqfile"
        guppyAdditionalParameters: "Additional parameters to be added to the guppy command"
        nanoplotAdditionalParameters: "Additional parameters to be added to the nanoplot command"
    }
    meta {
        output_meta : {
            mergedFastqFile: "merged output of all the fastq's gzipped",
            seqSummary: "sequencing summary of the basecalling",
            seqTelemetry: "sequencing telemetry of the basecalling"
        }
    }
    command <<<
        ~{guppy} \
        --num_callers ~{numCallers} \
        --chunks_per_runner ~{chunksPerRunner} \
        -r \
        --input_path ~{inputPath} \
        --save_path ~{guppySavePath}  \
        --flowcell ~{flowcell} \
        --kit ~{kit} \
        -x ~{basecallingDevice} \
        ~{guppyAdditionalParameters} \
        --disable_pings
        ~{nanoplot} --summary ~{guppySavePath}/~{sequencingSummaryFilename} -o ~{nanoplotSavePath} ~{nanoplotAdditionalParameters}
        zip -r ~{outputFileNamePrefix}_nanoplot.zip ~{nanoplotSavePath}
    >>>

    output {
        File nanoplotReport = "~{outputFileNamePrefix}_nanoplot.zip"
    }
    runtime {
        modules: "~{modules}"
        memory: "~{memory} GB"
        gpuCount: 2
        gpuType: "nvidia-tesla-v100"
        nvidiaDriverVersion: "396.26.00"
        docker: "guppy_nvidia_docker:1.1"
        dockerRuntime: "nvidia"
    }
}
