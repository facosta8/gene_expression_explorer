import pandas as pd 
import os 
import numpy as np
from LocalitySensitiveHashing import *
#Instalar BitVector

os.chdir('git/gene_expression_explorer')
gene = pd.read_csv('ejemplo/matriz_ejemplo.csv')
gene = gene.iloc[:,1:len(gene.columns)]
gene.to_csv('ejemplo/gene.csv')

gene = pd.read_csv('ejemplo/data_for_lsh.csv')

datafile = gene
dim = len(gene.columns)-1 # Is set to the dimensionality of the vector space in which the data is defined.
expected_num_of_clusters = 10 # This tell the module how many clusters you expect to see in your datafile.


lsh = LocalitySensitiveHashing(
                   datafile ='ejemplo/data_for_lsh.csv' ,
                   dim = dim,
                   r = 50,
                   b = 100,
                   expected_num_of_clusters = expected_num_of_clusters,
          )
lsh.get_data_from_csv()
lsh.initialize_hash_store()
lsh.hash_all_data()
similarity_groups = lsh.lsh_basic_for_neighborhood_clusters()
coalesced_similarity_groups = lsh.merge_similarity_groups_with_coalescence( similarity_groups )
merged_similarity_groups = lsh.merge_similarity_groups_with_l2norm_sample_based( coalesced_similarity_groups )
lsh.write_clusters_to_file( merged_similarity_groups, "ejemplo/clusters.txt" )




dim = 10
covar = np.diag([0.01] * dim)
output_file = 'ejemplo/data_for_lsh.csv'
data_gen = DataGenerator(
                          output_csv_file   = output_file,
                          how_many_similarity_groups = 10,
                          dim = dim,
                          number_of_samples_per_group = 8,
                          covariance = covar,
                        )

data_gen.gen_data_and_write_to_csv()











