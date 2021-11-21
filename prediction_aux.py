import json
import numpy as np
from matplotlib import pyplot as plt
from datetime import datetime
from statsmodels.tsa.statespace.varmax import VARMAX

import matplotlib.dates as pltd

# -----------------------------------------------------------------------
# ------------------------------ Load data ------------------------------
# -----------------------------------------------------------------------
def import_apt_data():
	with open('db.json') as f:
	    data = json.load(f)
	return data['houses'][0]['apartments']


# -----------------------------------------------------------------------
# ------------------------------ Functions ------------------------------
# -----------------------------------------------------------------------
def get_time_series(apartment_id, appliance, time_interval='day',
					samples=50):
	'''---Inputs---
		· apartment_id:  (int) 0 to 19.
		· appliance:	 (str) Hydractiva_shower
    						   Kitchen_optima_faucet
    						   Optima_faucet
    						   Washing_machine
    						   Dishwasher
		· time_interval: (str) 'year', 'month', 'day', or 'hour'.
		
		---Outputs---
		· consumption: (float, list) time series with the total consumption
					   in liters per time_interval.
		· temp: 	(float, list) time series with the average temperature
					per time_interval.
		· flowtime: (float, list) time series with the total usage time
					in seconds per time_interval.
		· power: 	(float, list) time series with the total consumption
				    in kWh per time_interval.
		· time: 	(float, list) times of measurement in seconds since
					1970-1-1.'''

	apartments = import_apt_data()

	consumption = []
	temp = []
	flowtime = []
	power = []
	time = []

	consumption_per_interval = []
	temp_per_interval = []
	flowtime_per_interval = []
	power_per_interval = []

	measurements = apartments[apartment_id][appliance]['measurements']

	if time_interval == 'year':
	    m = 4
	elif time_interval == 'month':
	    m = 7
	elif time_interval == 'day':
	    m = 10
	elif time_interval == 'hour':
	    m = 13

	c = 0
	prev_datestamp = measurements[0]['TimeStamp'][:m]
	for sample in measurements:
	    datestamp = sample['TimeStamp'][:m]
	    if not datestamp == prev_datestamp:

	        consumption += [np.sum(consumption_per_interval)]
	        temp += [np.mean(temp_per_interval)]
	        flowtime += [np.sum(flowtime_per_interval)]
	        power += [np.sum(power_per_interval)]
	        
	        year = int(sample['TimeStamp'][:4])
	        month = int(sample['TimeStamp'][5:7])
	        day = int(sample['TimeStamp'][8:10])
	        hour = int(sample['TimeStamp'][11:13])
	        minute = int(sample['TimeStamp'][14:16])
	        second = int(sample['TimeStamp'][17:19])
	            
	        if time_interval == 'year':
	            time += [datetime(year,7,1).timestamp()]
	        elif time_interval == 'month':
	            time += [datetime(year,month,15).timestamp()]
	        elif time_interval == 'day':
	            time += [datetime(year,month,day).timestamp()]
	        elif time_interval == 'hour':
	            time += [datetime(year,month,day,hour).timestamp()]
	        
	        consumption_per_interval = []
	        temp_per_interval = []
	        flowtime_per_interval = []
	        power_per_interval = []
	        c = 0

	    consumption_per_interval += [float(sample['Consumption'])]
	    temp_per_interval += [float(sample['Temp'])]
	    flowtime_per_interval += [float(sample['FlowTime'])]
	    power_per_interval += [float(sample['Power_Consumption'])]
	    c += 1

	    prev_datestamp = sample['TimeStamp'][:m]

	return consumption[-samples:], temp[-samples:], flowtime[-samples:], power[-samples:], time[-samples:]


def make_predictions(time_series, previous_data_points=7):
	p = previous_data_points
	q = previous_data_points

	## Consumption and FlowTime ##

	time_series_array = list(zip(time_series[0], time_series[2]))
	# Fit model
	model = VARMAX(time_series_array, order=(p,q))
	model_fit = model.fit(disp=False)
	# Make prediction
	predictions = model_fit.forecast(5) # Predict 5 following days
	consumption_pred = predictions[:,0]
	flowtime_pred = predictions[:,1]

	## Power (and FlowTime) ##

	time_series_array = list(zip(time_series[3], time_series[2]))
	# Fit model
	model = VARMAX(time_series_array, order=(p,q))
	model_fit = model.fit(disp=False)
	# Make prediction
	predictions = model_fit.forecast(5) # Predict 5 following days
	power_pred = predictions[:,0]

	return consumption_pred, flowtime_pred, power_pred

# -----------------------------------------------------------------------
# -------------------------------- Plots --------------------------------
# -----------------------------------------------------------------------
def plot_time_series(time, series):
	fig, ax = plt.subplots()

	dates = pltd.date2num(time)
	plt.plot_date(dates, series, linestyle='-', marker='')

	tick1 = datetime(2020,1,1).timestamp()
	tick2 = datetime(2020,5,1).timestamp()
	tick3 = datetime(2020,9,1).timestamp()
	tick4 = datetime(2021,1,1).timestamp()
	ax.set_xticks([pltd.date2num(tick1),pltd.date2num(tick2),
				   pltd.date2num(tick3),pltd.date2num(tick4)])
	ax.set_xticklabels(['Jan 2020', 'May 2020', 'Sept 2020', 'Jan 2021'])

	#plt.xlim([pltd.date2num(datetime(2020,1,1).timestamp()),
	#		   pltd.date2num(datetime(2020,3,1).timestamp())])

	plt.show()



































































