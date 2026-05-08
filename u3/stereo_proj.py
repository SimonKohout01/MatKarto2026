from math import *

# Optimal LCC projection
R = 1


# CHILE

# Pole
uk_chile = -39.149663442348 * pi/180 # - here because it is SOUTH
vk_chile = -69.870457809981 * pi/180 # - here because it is WEST

# Point on our parallel
u1_chile = -17.498348117325 * pi/180
v1_chile = -69.468452095788 * pi/180


# Transformation to the oblique aspect
s1_chile = asin(sin(u1_chile) * sin(uk_chile) + cos(u1_chile) * cos(uk_chile) * cos(vk_chile-v1_chile))

# Addition to 90° (pi/2)
psi_chile = pi/2 - s1_chile

# Multiplication constant 
mi_n_chile = 2*(cos(psi_chile/2))**2
mi_d_chile = 1+(cos(psi_chile/2))**2
mi_chile = mi_n_chile/mi_d_chile

# Compute psi0
psi0_chile = 2*acos(sqrt(mi_chile))

# Scales
m1_chile = ((cos(psi0_chile/2))**2)/((cos(psi_chile/2))**2)
m0_chile = ((cos(psi0_chile/2))**2)/1


# Distortions 
ny1_chile = round(m1_chile-1,6)
ny0_chile = round(m0_chile-1,6)
print("CHILE DISTORTION", ny1_chile, ny0_chile)


# SVYCARSKO

# Pole
uk_svyc = 46.172892578606 * pi/180 # + here because it is NORTH
vk_svyc = 8.360322437409 * pi/180 # + here because it is EAST

# Point on our parallel
u1_svyc = 44.777134671027 * pi/180
v1_svyc = 9.706736752027 * pi/180


# Transformation to the oblique aspect
s1_svyc = asin(sin(u1_svyc) * sin(uk_svyc) + cos(u1_svyc) * cos(uk_svyc) * cos(vk_svyc-v1_svyc))

# Addition to 90° (pi/2)
psi_svyc = pi/2 - s1_svyc

# Multiplication constant 
mi_n_svyc = 2*(cos(psi_svyc/2))**2
mi_d_svyc = 1+(cos(psi_svyc/2))**2
mi_svyc = mi_n_svyc/mi_d_svyc

# Compute psi0
psi0_svyc = 2*acos(sqrt(mi_svyc))

# Scales
m1_svyc = ((cos(psi0_svyc/2))**2)/((cos(psi_svyc/2))**2)
m0_svyc = ((cos(psi0_svyc/2))**2)/1


# Distortions 
ny1_svyc = round(m1_svyc-1,6)
ny0_svyc = round(m0_svyc-1,6)
print("Switzerland DISTORTION", ny1_svyc, ny0_svyc)