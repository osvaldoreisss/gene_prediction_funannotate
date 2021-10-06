rule clean_assembly:
    input: get_assembly
    output: 
        "results/assembly_clean/{sample}.clean.fasta"
    conda:
        "../envs/funannotate.yaml"
    log: "results/log/clean/{sample}.clean.log"
    params:
        **config["params"]
    shell: 
        """
        funannotate clean {params.clean} -i {input} -o {output} 2> {log}
        """