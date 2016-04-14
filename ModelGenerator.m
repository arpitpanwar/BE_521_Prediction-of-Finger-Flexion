addpath(genpath('../ieeg-matlab-1.13.2/'));

[model_linear_regression,predictions_linear_reg] = GenerateLinearRegression();
[model_ensemble_learning,predictions_ensemble] = GenerateEnsembleLearning();


save('SavedModels.mat','model_linear_regression','model_ensemble_learning');