#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0

requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  facets_vcf:
    type: File
    secondaryFiles:
      - .gz

  bam_normal:
    type: File

  bam_tumor:
    type: File
 
  tumor_id:
    type: string

  facets_output_prefix:
    type: string

  snp_pileup_output_file_name:
    type: string
 
  params:
    type:
      type: record
      fields:
        pseudo_snps: int
        count_orphans: boolean
        gzip: boolean
        ignore_overlaps: boolean
        max_depth: int
        min_base_quality: int
        min_read_counts: int
        min_map_quality: int
        cval: int
        snp_nbhd: int
        ndepth: int
        min_nhet: int
        purity_cval: int
        purity_snp_nbhd: int
        purity_ndepth: int
        purity_min_nhet: int
        genome: string
        directory: string
        R_lib: string
        single_chrom: string
        ggplot2: string
        seed: int
        dipLogR: float?

outputs:

  snp_pileup_out:
    type: File
    outputSource: do_snp_pileup/output_file

  facets_png: 
    type: File[]?
    outputSource: do_facets/png_files

  facets_txt_purity:
    type: File?
    outputSource: do_facets/txt_files_purity

  facets_txt_hisens:
    type: File?
    outputSource: do_facets/txt_files_hisens

  facets_out_files:
    type: File[]?
    outputSource: do_facets/out_files

  facets_rdata:
    type: File[]?
    outputSource: do_facets/rdata_files

  facets_seg:
    type: File[]?
    outputSource: do_facets/seg_files

steps:

  do_snp_pileup:
    run: ./command_line_tools/htstools_0.1.1/snp-pileup.cwl
    in:
        params: params
        vcf_file: facets_vcf
        bam_normal: bam_normal
        bam_tumor: bam_tumor
        pseudo_snps: 
          valueFrom: $(inputs.params.pseudo_snps)
        count_orphans: 
          valueFrom: $(inputs.params.count_orphans)
        gzip: 
          valueFrom: $(inputs.params.gzip)
        ignore_overlaps: 
          valueFrom: $(inputs.params.ignore_overlaps)
        max_depth: 
          valueFrom: $(inputs.params.max_depth)
        min_base_quality: 
          valueFrom: $(inputs.params.min_base_quality)
        min_read_counts: 
          valueFrom: $(inputs.params.min_read_counts)
        min_map_quality: 
          valueFrom: $(inputs.params.min_map_quality)
        output_file: snp_pileup_output_file_name
    out: [ output_file ]

  do_facets:
    run: ./command_line_tools/facets_1.5.6/facets.doFacets-1.5.6.cwl
    in:
      params: params
      counts_file: do_snp_pileup/output_file
      TAG: facets_output_prefix
      tumor_id: tumor_id
      cval: 
          valueFrom: $(inputs.params.cval)
      snp_nbhd: 
          valueFrom: $(inputs.params.snp_nbhd)
      ndepth: 
          valueFrom: $(inputs.params.ndepth)
      min_nhet: 
          valueFrom: $(inputs.params.min_nhet)
      purity_cval: 
          valueFrom: $(inputs.params.purity_cval)
      purity_snp_nbhd: 
          valueFrom: $(inputs.params.purity_snp_nbhd)
      purity_ndepth: 
          valueFrom: $(inputs.params.purity_ndepth)
      purity_min_nhet: 
          valueFrom: $(inputs.params.purity_min_nhet)
      genome: 
          valueFrom: $(inputs.params.genome)
      directory: 
          valueFrom: $(inputs.params.directory)
      R_lib: 
          valueFrom: $(inputs.params.R_lib)
      single_chrom: 
          valueFrom: $(inputs.params.single_chrom)
      ggplot2: 
          valueFrom: $(inputs.params.ggplot2)
      seed: 
          valueFrom: $(inputs.params.seed)
      dipLogR:
          valueFrom: $(inputs.params.dipLogR)
    out: [ png_files, txt_files_purity, txt_files_hisens, out_files, rdata_files, seg_files ]
