from snakemake.utils import validate
import pandas as pd

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep=",").set_index("sample", drop=False)

threads_repeat_modeler = config['threads_repeat_modeler']
threads_repeat_masker = config['threads_repeat_masker']

def get_assembly(wildcards):
    assembly = samples.loc[(wildcards.sample), ["fasta"]].dropna()
    return f"resources/{assembly.fasta}"