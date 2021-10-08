rule build_database:
    input: 
        "results/assembly_clean/{sample}.clean.fasta"
    output: 
        "results/repeat_modeler_database/{sample}.clean"
    conda:
        "../envs/repeat_modeler.yaml"
    log: 
        "results/log/build_database/{sample}.log"
    shell: 
        """
        BuildDatabase -name {output} {input} 2> {log}
        touch {output}
        """

rule repeat_modeler:
    input:
        "results/repeat_modeler_database/{sample}.clean"
    output: 
        "results/repeat_modeler/{sample}.clean"
    conda:
        "../envs/repeat_modeler.yaml"
    log: 
        "results/log/repeat_modeler/{sample}.log"
    threads: threads_repeat_modeler
    shell: 
        """
        RepeatModeler -pa {threads} -LTRStruct -database {input}
        """

rule repeat_masker:
    input:
        "results/assembly_clean/{sample}.clean.fasta",
        "results/repeat_modeler/{sample}.clean"
    output: 
        "results/repeat_masker/{sample}.clean.masked.fasta"
    conda:
        "../envs/funannotate.yaml"
    log: 
        "results/log/repeat_masker/{sample}.log"
    threads: threads_repeat_masker
    shell: 
        """
        funannotate mask -i {input[0]} -o {output} -m repeatmasker --cpus {threads} -l {input[1]}-families.fa
        """