import shapefile
from math import *

#Convert to oblique aspect
def uvTosd(u, v, uk, vk):
    dv = vk - v
    sarg = sin(u) * sin(uk) + cos(u) * cos(dv) * cos(uk)
    s = asin(sarg)
    return s, 0 # we need only s here

#Find extreme latitude in shapefile
def find_extreme_s(file_path, uk, vk):
    sf = shapefile.Reader(file_path)
    max_s = 0.0 # start value
    
    #Loop all polygon shapes
    for shp in sf.shapes():
        for p in shp.points:
            lon = p[0]
            lat = p[1]
            
            #Deg to rad
            u = lat * pi / 180
            v = lon * pi / 180
            
            s = uvTosd(u, v, uk, vk)[0]
            
            #Save absolute biggest distance
            if abs(s) > max_s:
                max_s = abs(s)
                
    return max_s