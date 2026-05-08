from math import *

# Optimal LCC projection
R = 1


# CHILE

# Pole
uk_chile = -40.832077273896 * pi/180 # - here because it is SOUTH
vk_chile = -13.909493649908 * pi/180 # - here because it is WEST

# Northernmost point
u1_chile = -52.334371968279 * pi/180
v1_chile = -68.417793112652 * pi/180

# Southernmost point
u2_chile = -53.006038981235 * pi/180
v2_chile = -73.851978371579 * pi/180

# Transformation to the oblique aspect
s1_chile = asin(sin(u1_chile) * sin(uk_chile) + cos(u1_chile) * cos(uk_chile) * cos(vk_chile-v1_chile))
s2_chile = asin(sin(u2_chile) * sin(uk_chile) + cos(u2_chile) * cos(uk_chile) * cos(vk_chile-v2_chile))

# Constant c of the conic projection
cn_chile = log10(cos(s1_chile)) - log10(cos(s2_chile))
cd_chile = log10(tan(s2_chile/2+pi/4))-log10(tan(s1_chile/2+pi/4))
c_chile = cn_chile / cd_chile

# Compute s0
s0_chile = asin(c_chile)

# Compute rho0: radius of the parallel (u = u0)
rho0_n_chile = 2*R*cos(s0_chile)*cos(s1_chile)*(tan(s1_chile/2+pi/4))**c_chile
rho0_d_chile = c_chile*(cos(s0_chile)*(tan(s0_chile/2+pi/4))**c_chile+cos(s1_chile)*(tan(s1_chile/2+pi/4))**c_chile)
rho0_chile = rho0_n_chile/rho0_d_chile

# Compute rho1: radius of the north parallel (u = u1)
rho1_chile = rho0_chile*((tan(s0_chile/2+pi/4))/(tan(s1_chile/2+pi/4)))**c_chile

# Compute rho2: radius of the south parallel (u = u2)
rho2_chile = rho0_chile*((tan(s0_chile/2+pi/4))/(tan(s2_chile/2+pi/4)))**c_chile

# Scales
m1_chile = (c_chile * rho1_chile)/(R * cos(s1_chile))
m2_chile = (c_chile * rho2_chile)/(R * cos(s2_chile))
m0_chile = (c_chile * rho0_chile)/(R * cos(s0_chile))

ny1_chile = round(m1_chile -1,6)
ny2_chile = round(m2_chile -1,6)
ny0_chile = round(m0_chile -1,6)

print("CHILE DISTORTION: Northern parallel =", ny1_chile,"Southern parallel =", ny2_chile,"Middle parallel =", ny0_chile)


# SVYCARSKO

# Pole
uk_svyc = 46.112849306762 * pi/180 # + here because it is NORTH
vk_svyc = 8.448352102567 * pi/180 # + here because it is EAST

# Northernmost point
u1_svyc = 46.162394752306 * pi/180
v1_svyc = 8.578877501097 * pi/180

# Southernmost point
u2_svyc = 47.188547905213 * pi/180
v2_svyc = 10.383944567683 * pi/180

# Transformation to the oblique aspect
s1_svyc = asin(sin(u1_svyc) * sin(uk_svyc) + cos(u1_svyc) * cos(uk_svyc) * cos(vk_svyc-v1_svyc))
s2_svyc = asin(sin(u2_svyc) * sin(uk_svyc) + cos(u2_svyc) * cos(uk_svyc) * cos(vk_svyc-v2_svyc))

# Constant c of the conic projection
cn_svyc = log10(cos(s1_svyc)) - log10(cos(s2_svyc))
cd_svyc = log10(tan(s2_svyc/2+pi/4))-log10(tan(s1_svyc/2+pi/4))
c_svyc = cn_svyc / cd_svyc

# Compute s0
s0_svyc = asin(c_svyc)

# Compute rho0: radius of the parallel (u = u0)
rho0_n_svyc = 2*R*cos(s0_svyc)*cos(s1_svyc)*(tan(s1_svyc/2+pi/4))**c_svyc
rho0_d_svyc = c_svyc*(cos(s0_svyc)*(tan(s0_svyc/2+pi/4))**c_svyc+cos(s1_svyc)*(tan(s1_svyc/2+pi/4))**c_svyc)
rho0_svyc = rho0_n_svyc/rho0_d_svyc

# Compute rho1: radius of the north parallel (u = u1)
rho1_svyc = rho0_svyc*((tan(s0_svyc/2+pi/4))/(tan(s1_svyc/2+pi/4)))**c_svyc

# Compute rho2: radius of the south parallel (u = u2)
rho2_svyc = rho0_svyc*((tan(s0_svyc/2+pi/4))/(tan(s2_svyc/2+pi/4)))**c_svyc

# Scales
m1_svyc = (c_svyc * rho1_svyc)/(R * cos(s1_svyc))
m2_svyc = (c_svyc * rho2_svyc)/(R * cos(s2_svyc))
m0_svyc = (c_svyc * rho0_svyc)/(R * cos(s0_svyc))

ny1_svyc = round(m1_svyc - 1,6)
ny2_svyc = round(m2_svyc - 1,6)
ny0_svyc = round(m0_svyc - 1,6)

print("SWITZERLAND DISTORTION: Northern parallel =", ny1_svyc,"Southern parallel =", ny2_svyc,"Middle Parallel =", ny0_svyc)