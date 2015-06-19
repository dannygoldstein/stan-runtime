import numpy as np
import pickle
import pystan

name = 'gp_fitpredict_joint_cholesky'
nug = 1e-6
N1 = 100
N2 = 20 
D = 2
x1 = np.random.random((N1, D)) * 10
y1 = np.sin(np.sqrt((x1**2).sum(axis=1)))
x2 = np.random.random((N2, D)) * 10

data = {'nug':nug,
        'D':D,
        'N1':N1,
        'N2':N2,
        'x1':x1,
        'x2':x2,
        'y1':y1}

model  = pystan.StanModel(file='%s.stan' % name, model_name='%s' % name)
pickle.dump(model, open('%s_model.pkl' % name, 'wb'))
result = model.sampling(data=data, n_jobs=24)

#requires pystan > 2.6
pickle.dump(result, open('%s_result.pkl' % name,'wb'))

