rule annotation:
    input:
        "results/repeat_masker/{sample}.clean.masked.fasta",
        "results/funannotate_db"
    output: 
        directory("results/funannotate_{sample}")
    conda:
        "../envs/funannotate.yaml"
    log: 
        "results/log/funannotate/{sample}.log"
    params:
        **config["params"]
    threads: threads_repeat_masker
    shell: 
        """
        funannotate predict -i {input[0]} -o {output} --isolate {wildcards.sample} \
        --database {input[1]} --cpus {threads} {params.predict} 2> {log}
        """

rule funannotate_setup:
    output: 
        "results/funannotate_db"
    conda:
        "../envs/funannotate.yaml"
    log:
        "results/log/funannotate_setup/setup.log"
    shell: 
        "funannotate setup -d {output} 2> {log}"