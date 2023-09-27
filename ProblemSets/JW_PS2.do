
*a
 
cd "/Users/janetjw/Dropbox (University of Michigan)/STATS506/ProblemSets/"
import delimited "cars.csv"

rename (*) (height length width driveline enginetype hybrid forwardgears transmission city fueltype highway classification id make modelyear year horsepower torque)


*b
keep if fueltype == "Gasoline"

*c

reg highway horsepower torque height length width i.year

*d
reg highway c.horsepower##c.torque height length width i.year

codebook torque
codebook horsepower

margins, at(horsepower=( 200 400 600 ) torque = (177 267.22 332) year = 2011)

marginsplot

*e

gen year2010 = 0
replace year2010 =1 if year == 2010
gen year2011 = 0
replace year2011  =1 if year == 2011
gen year2012 = 0
replace year2012  =1 if year == 2012
gen horsepowerxtorque = horsepower * torque
gen inter = 1

mata

X = st_data(.,("inter", "horsepower", "torque", "height", "length", "width", "year2010", "year2011", "year2012", "horsepowerxtorque"))

y = st_data(.,("highway"))


invsym(X'*X)*X'*y

end
