from math import *
from uvtosd import *

#Angle conversion
def radToDms(rad):
    #Convert radians to decimal degrees
    deg_dec = rad * 180 / pi
    
    #Get whole degrees
    d = int(deg_dec)
    
    #Get whole minutes
    m_dec = (deg_dec - d) * 60
    m = int(m_dec)
    
    #Get seconds
    s = (m_dec - m) * 60
    
    return d, m, s

#Input coordinates point 1 (Prague)
u11 = 50.0691914
v11 = 14.4249158
u12 = 50.0691890
v12 = 14.4249145
u13 = 50.0691931
v13 = 14.4249169

#Input coordinates point 2 (Prague)
u21 = 50.1274507
v21 = 14.4909381
u22 = 50.1274351
v22 = 14.4909124
u23 = 50.1274426
v23 = 14.4909504

#Average of measurements
phi_WGS = (u11 + u12 + u13) / 3 * pi/180
la_WGS = (v11 + v12 + v13) / 3 * pi/180

phi_WGS2 = (u21 + u22 + u23) / 3 * pi/180
la_WGS2 = (v21 + v22 + v23) / 3 * pi/180


def WGSToJTSK(phi_WGS, la_WGS):
    #WGS84 parameters
    a_WGS = 6378137.00
    b_WGS = 6356752.3142
    
    e2_WGS = (a_WGS*a_WGS - b_WGS*b_WGS)/(a_WGS*a_WGS)
    W_WGS = sqrt(1-e2_WGS*(sin(phi_WGS))**2)
    N_WGS = a_WGS/W_WGS
    
    #XYZ coordinates, WGS 84
    X_WGS = N_WGS * (cos(phi_WGS) * cos(la_WGS))
    Y_WGS = N_WGS * (cos(phi_WGS) * sin(la_WGS))
    Z_WGS = N_WGS * (1 - e2_WGS) * sin(phi_WGS)
    
    #Helmert transformation, parameters
    om_x = 4.9984 / 3600 * pi /180 
    om_y = 1.5867 /3600 * pi / 180
    om_z = 5.2611 /3600 * pi / 180
    m = 1 - 3.5623e-06
    dlt_x = -570.8285
    dlt_y = -85.6769
    dlt_z = -462.8420
    
    #Helmert transformation, Bessel ellipsoid
    X_Bes = m * (X_WGS + Y_WGS * om_z - om_y * Z_WGS) + dlt_x
    Y_Bes = m * (-om_z * X_WGS + Y_WGS + om_x * Z_WGS) + dlt_y
    Z_Bes = m * (om_y * X_WGS - om_x * Y_WGS + Z_WGS) + dlt_z
    
    #Bessel parameters
    a_Bes = 6377397.155
    b_Bes = 6356078.963
    e2_Bes = (a_Bes*a_Bes - b_Bes*b_Bes)/(a_Bes*a_Bes)
   
    #Phi, lam, Bessel
    la_Bes = atan2(Y_Bes,X_Bes)
    tan_phi_Bes = Z_Bes / ((1 - e2_Bes) * sqrt(X_Bes**2 + Y_Bes**2))
    phi_Bes = atan(tan_phi_Bes)
    
    #Shift to Feerro
    la_Ferro = la_Bes + (17 + 2/3) * pi / 180
    
    #Gauss conformal projection, parameters
    phi0 = 49.5 * pi / 180
    alpha = sqrt (1 + e2_Bes * (cos(phi0))**4 / (1 - e2_Bes))
    u0 = asin(sin(phi0)/alpha)
    
    kn = (tan(phi0/2+pi/4)**alpha*((1-sqrt(e2_Bes)*sin(phi0))/(1+sqrt(e2_Bes)*sin(phi0)))**(alpha*sqrt(e2_Bes)/2))
    kd = tan(u0/2+pi/4)
    k = kn / kd
    
    R = (a_Bes*sqrt(1-e2_Bes))/(1-e2_Bes*(sin(phi0)**2))
 
    #Gauss conformal projection
    #u = 2*(atan(1/k*(tan(phi_Bes/2+pi/4)*((1-sqrt(e2_Bes))/(1+sqrt(e2_Bes)))**(sqrt(e2_Bes)/2))**alpha))-pi/2
    u = 2*(atan(1/k*(tan(phi_Bes/2+pi/4)*((1-sqrt(e2_Bes)*sin(phi_Bes))/(1+sqrt(e2_Bes)*sin(phi_Bes)))**(sqrt(e2_Bes)/2))**alpha))-pi/2
    v = alpha*la_Ferro
    
    #Cartographic pole
    uk = (59+(42/60)+(42.6969/3600))*(pi/180)
    vk = (42+(31/60)+(31.41725/3600))*(pi/180)
    
    #Conversion (u, v) -> (s, d)
    s, d = uvTosd(u, v, uk, vk)
    
    #LCC
    s0 = 78.5 * pi/180
    rho0 = R*1/tan(s0)*0.9999
    c = sin(s0)
    
    rho = rho0*((tan(s0/2+pi/4))/(tan(s/2+pi/4)))**c
    eps = c * d
    
    # (rho, eps) -> (y, x)
    y_jtsk = rho*sin(eps)
    x_jtsk = rho*cos(eps)
    
    #Local linear scale and distortion
    m_r = (c * rho) / (R * cos(s))
    m_zkresleni = m_r - 1
    
    #Meridian convergence calculation
    ksi = asin(cos(uk) * sin(pi - d) / cos(u))
    c_konvergence = (eps - ksi) * 180 / pi
    
    #We must add phi_Bes to return statement
    return x_jtsk, y_jtsk, m_r, m_zkresleni, c_konvergence, phi_Bes


#Call function for point 1
print("Point 1")
x1, y1, m_r1, m_zkresleni1, c_konv1, phi_bes1 = WGSToJTSK(phi_WGS, la_WGS)
d1, m1, s1 = radToDms(phi_bes1)

#Print output with required precision
print(f"Y: {y1:.3f} m")
print(f"X: {x1:.3f} m")
print(f"Phi on Bessel: {d1}° {m1}' {s1:.3f}''")
print(f"Local scale (mr): {m_r1:.8f}")
print(f"Distortion (m-1): {m_zkresleni1:.8f}")
print(f"Convergence (c): {c_konv1:.4f}°")


#Call function for point 2
print("Point 2")
x2, y2, m_r2, m_zkresleni2, c_konv2, phi_bes2 = WGSToJTSK(phi_WGS2, la_WGS2)
d2, m2, s2 = radToDms(phi_bes2)

print(f"Y: {y2:.3f} m")
print(f"X: {x2:.3f} m")
print(f"Phi on Bessel: {d2}° {m2}' {s2:.3f}''")
print(f"Local scale (mr): {m_r2:.8f}")
print(f"Distortion (m-2): {m_zkresleni2:.8f}")
print(f"Convergence (c): {c_konv2:.4f}°")


#Distance calculation P1 - P2
print("Distance P1 - P2")
distance_jtsk = sqrt((x2 - x1)**2 + (y2 - y1)**2)
print(f"Distance in JTSK: {distance_jtsk:.2f} m")