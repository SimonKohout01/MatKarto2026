from math import *
from s0_bonus import find_extreme_s

#Optimal conformal projection for Chile

#Defining functions for the bonus 
def geo_to_xyz(u, v):
    #Convert geography angles to 3D vector
    x = cos(u) * cos(v)
    y = cos(u) * sin(v)
    z = sin(u)
    return [x, y, z]

def my_cross_product(a, b):
    #Cross product for two vectors without numpy
    cx = a[1] * b[2] - a[2] * b[1]
    cy = a[2] * b[0] - a[0] * b[2]
    cz = a[0] * b[1] - a[1] * b[0]
    return [cx, cy, cz]


#Poin ts on the quator
u2 = -41.711194781*pi/180
v2 = -71.294470110*pi/180
u1 = -26.189752142*pi/180
v1 = -71.592771329*pi/180

#Northernmost point
#u3 = -22.629705177*pi/180
#v3 = -66.996751822*pi/180

u3 = -19.578328530*pi/180
v3 = -76.246879022*pi/180

#Southernmost point
u4 = -50.739861219*pi/180
v4 = -66.497675853*pi/180


#u4 = -50.739861219*pi/180
#v4 = 50.739861219*pi/180
 
#Pole using spherical trigonometry
vk = atan2(tan(u1)*cos(v2)-tan(u2)*cos(v1), tan(u2)*sin(v1)-tan(u1)*sin(v2))
uk = atan(-1/tan(u2)*cos(vk-v2))

#Pole using analytic geometry
#Get 3D vectors from our equator points
vec_p1 = geo_to_xyz(u1, v1)
vec_p2 = geo_to_xyz(u2, v2)

#Cross product makes normal vector
vec_n = my_cross_product(vec_p1, vec_p2)

#Normalize vector length to 1
length_n = sqrt(vec_n[0]**2 + vec_n[1]**2 + vec_n[2]**2)
norm_x = vec_n[0] / length_n
norm_y = vec_n[1] / length_n
norm_z = vec_n[2] / length_n

#Convert back to geographic angles
analytic_uk = asin(norm_z)
analytic_vk = atan2(norm_y, norm_x)


#Transformation to the oblique aspect
s1 = asin(sin(u1) * sin(uk) + cos(u1) * cos(uk) * cos(vk-v1))
s2 = asin(sin(u2) * sin(uk) + cos(u2) * cos(uk) * cos(vk-v2))
s3 = asin(sin(u3) * sin(uk) + cos(u3) * cos(uk) * cos(vk-v3))
s4 = asin(sin(u4) * sin(uk) + cos(u4) * cos(uk) * cos(vk-v4))

#True parallel
s0 = acos (2*cos(s3)/(1+cos(s3)))

#Exact s0 bonus 1
#We use our helper function and chile.shp
s_extreme = find_extreme_s("chile.shp", uk, vk)
s0_exact = acos(2 * cos(s_extreme) / (1 + cos(s_extreme)))

print("True parallel comparison")
print(f"Manual s0: {s0 * 180/pi:.6f} degrees")
print(f"Exact s0:  {s0_exact * 180/pi:.6f} degrees")

#Scales
m1 = cos(s0)/cos(s1)
m2 = cos(s0)/cos(s2)
m3 = cos(s0)/cos(s3)
m4 = cos(s0)/cos(s4)

#Distortions
ny1 = (m1 -1) *1000
ny2 = (m2 -1) *1000
ny3 = (m3 -1) *1000
ny4 = (m4 -1) *1000

#Scales
m1_exact = cos(s0_exact)/cos(s1)
m2_exact = cos(s0_exact)/cos(s2)
m3_exact = cos(s0_exact)/cos(s3)
m4_exact = cos(s0_exact)/cos(s4)

#Distortions
ny1_exact = (m1_exact -1) *1000
ny2_exact = (m2_exact -1) *1000
ny3_exact = (m3_exact -1) *1000
ny4_exact = (m4_exact -1) *1000


#Print results formatted to 6 decimal places
print("Distortions for Chile:")
print(f"P1:{ny1:.6f}")
print(f"P2:{ny2:.6f}")
print(f"P3:{ny3:.6f}")
print(f"P4:{ny4:.6f}")

#Print results formatted to 6 decimal places
print("Distortions for Chile exact:")
print(f"P1:{ny1_exact:.6f}")
print(f"P2:{ny2_exact:.6f}")
print(f"P3:{ny3_exact:.6f}")
print(f"P4:{ny4_exact:.6f}")

print("Pole K (Spherical trigonometry):", "uk:", uk * 180/pi, "vk:", vk * 180/pi)
print("Pole K (Analytic geometry):", "uk:", analytic_uk * 180/pi, "vk:", analytic_vk * 180/pi)






