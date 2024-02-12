pv2016_hour = 1000 * min_to_hour("Ppv2016.mat");
pv_power_2016 = [[1:8760].' ,pv2016_hour];
pv2017_hour = 1000 * min_to_hour("Ppv2017.mat");
pv_power_2017 = [[1:8760].' ,pv2017_hour];
pv_power_2ans = [[1:17520].', [pv2016_hour; pv2017_hour]];
pconso2016_hour = 1000 * 3 * (min_to_hour("PconsoN22016.mat") + min_to_hour("PconsoN12016.mat"));
pconso2016 = [[1:8760].' ,pconso2016_hour];
pconso2017_hour = 1000 * 3 * (min_to_hour("PconsoN22017.mat") + min_to_hour("PconsoN12016.mat"));
pconso2017 = [[1:8760].' ,pconso2017_hour];
pconso_2ans = [[1:17520].', [pconso2016_hour; pconso2017_hour]];
nb_cycle_hour = 0.068;

type_battery = 1;
% cas batteries Plomb
if type_battery == 0
    simu_title = 'Solar_Batt_H2_PowerFlow_Solution_Plomb.slx';
% cas batteries Lithium-ion
else
    simu_title = 'Solar_Batt_H2_PowerFlow_Solution_Lithium.slx';
end

%% Étude 1: dépendance au réseau en fonction du nb de panneau solaire sans batteries
% n_batt=0;
% P_reseau= [];
% range = 1:100;
% for nb_set_solar_panel=range
%     out = sim(simu_title, 17520);
%     P_reseau = [P_reseau; sum(out.P_res_conso)];
% end
% plot(range, P_reseau)
% xlabel('nb set solar panel')
% ylabel('Energy (Wh)')
% title('Energy needed from the electric network without battery ','FontSize',12)
% %on fixe suite à l'étude 1 le nb de set de panneau solaire à 20.

nb_set_solar_panel = 20;
if type_battery == 0
    k1=1;
    cout_moy_batt = 2000*conversion_dollar;
else
    k1=0.6705;
    cout_moy_batt = 3300*conversion_dollar;
end

%% Étude 2, dimensionnement du nombre de batteries de sorte à minimiser le coût d'achat des batteries et de l'électricité.
% conversion_dollar = 0.91;
% prix_kwh = 0.15;
% range = 1:100;
% couts = [];
% for n_batt = range
%     out = sim(simu_title, 17520);
%     P_reseau_conso = sum(out.P_res_conso);
%     P_batt_stockee = sum(out.PB);
%     cout = cout_moy_batt*n_batt + P_reseau_conso*(prix_kwh/1000);
%     couts = [couts; cout];
% end
% plot(range, couts)
% xlabel('nb batt')
% ylabel('Coûts (€)')

%% Étude 3, dimensionnement du nombre de batteries de sorte à minimiser la puissance prélevée au réseau.
% prix_kwh = 0.15;
% range = 1:100;
% P_reseau = [];
% for n_batt = range
%     out = sim(simu_title, 17520);
%     P_reseau_conso = sum(out.P_res_conso);
%     P_reseau = [P_reseau; P_reseau_conso];
% end
% plot(range, P_reseau)
% xlabel('nb batt')
% ylabel('P_reseau (Wh)')
% title('Energy needed from the electric network','FontSize',12)

if type_battery == 0
    n_batt=45;
else
    n_batt=40;
end

%% Étude 4, simulation du modèle
% range = 1:100;
% out = sim(simu_title, 17520);
% P_reseau_conso = sum(out.P_res_conso);
% P_tot_conso = -sum(pconso_2ans(:,2));
% autosuffisance = (P_tot_conso - P_reseau_conso) / P_tot_conso
% prix_wh = 0.1493/1000;
% P_reseau_prix = P_reseau_conso*prix_wh
% conversion_dollar = 0.91;
% n_batt_prix = n_batt*cout_moy_batt

%% Étude 5 sur le nb de cycle et sur le SoH
% out = sim(simu_title, 17520); 
% digits(4);
% cycle_30 = 0;
% cycle_50 = 0;
% cycle_100 = 0;
% c = vpa(rainflow(out.SoC.Data));
% SoH_list = [];
% SoH = 100;
% nb_cycle=0;
% syms Nc
% for i = 1:length(c)
%     cycle_actuel = c(i,1);
%     ampli_actuelle = c(i,2);
%     mean_actuel = c(i, 3);
%     min_actuel = mean_actuel - ampli_actuelle/2;
% 
%     if min_actuel < 0.25
%                 if type_battery == 0
%                     eq = -6.5714*(Nc/100)^2 +21.029*(Nc/100) +85.4 - SoH == 0;
%                 else
%                     eq = 6*10^(-7)*Nc^2 -0.011*Nc +101.36 - SoH == 0;
%                 end
%         s_Nc = solve(eq,Nc);
%         N_actu = max(s_Nc) + cycle_actuel * ampli_actuelle;
%         if type_battery == 0
%             SoH = -6.5714*(N_actu/100)^2 +21.029*(N_actu/100) +85.4;
%         else
%             SoH = 6*10^(-7)*N_actu^2 -0.011*N_actu +101.36;
%         end
%         SoH_list = [SoH_list; SoH];
%         cycle_100 = cycle_100 + cycle_actuel * ampli_actuelle;
% 
% 
% 
%     elseif min_actuel < 0.6
%                 if type_battery == 0
%                     eq = -1.6991*(Nc/100)^2 +11.491*(Nc/100) +85.238 - SoH == 0;
%                 else
%                     eq = 5*10^(-8)*Nc^2 -0.0034*Nc +100.74 - SoH == 0;
%                 end
%         s_Nc = solve(eq,Nc);
%         N_actu = max(s_Nc) + cycle_actuel * ampli_actuelle;
%         if type_battery == 0
%             SoH = -1.6991*(N_actu/100)^2 +11.491*(N_actu/100) +85.238;
%         else
%             SoH = 5*10^(-8)*N_actu^2 -0.0034*N_actu +100.74;
%         end
%         SoH_list = [SoH_list; SoH];
%         cycle_50 = cycle_50 + cycle_actuel * ampli_actuelle;
% 
% 
%     else
%         if type_battery == 0
%             eq = -0.4739*(Nc/100)^2 +4.2294*(Nc/100) +91.923- SoH == 0;
%         else
%             eq = 10^(-7)*Nc^2 -0.0029*Nc +101.65- SoH == 0;
%         end
%         s_Nc = solve(eq,Nc);
%         N_actu = max(s_Nc) + cycle_actuel * ampli_actuelle;
%         if type_battery == 0
%             SoH = -0.4739*(N_actu/100)^2 +4.2294*(N_actu/100) +91.923; 
%         else
%             SoH = 10^(-7)*N_actu^2 -0.0029*N_actu +101.65;
%         end
%         SoH_list = [SoH_list; SoH];
%         cycle_30 = cycle_30 + cycle_actuel * ampli_actuelle;
% 
%     end
%     SoH
% end
% plot(1:length(c), SoH_list)
