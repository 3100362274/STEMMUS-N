Sim_output.SoilMoisture=Sim_output.SoilMoisture';
Sim_output.SoilTemperature=Sim_output.SoilTemperature';
Sim_output.AirPressure=Sim_output.AirPressure';
Sim_output.Precipitation=Sim_output.Precipitation';
Sim_output.AmmoniumTotalConc=Sim_output.AmmoniumTotalConc';
Sim_output.NitrateTotalConc=Sim_output.NitrateTotalConc';

writematrix(Sim_output.SoilMoisture,'SM.csv');
writematrix(Sim_output.SoilTemperature,'ST.csv');
writematrix( Sim_output.AirPressure,'Pg.csv');
writematrix( Sim_output.Precipitation,'pp.csv');
writematrix(    Sim_output.AmmoniumTotalConc,'Am.csv');
writematrix(  Sim_output.NitrateTotalConc,'Ni.csv');
writematrix(  current_date,'date.csv');
writematrix(  flux_vars.QNO33,'QNO3.csv');
writematrix(  flux_vars.QLiquid,'QLiquid.csv');