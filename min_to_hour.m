function data_hour=min_to_hour(file)
    data_min = extractfield(load(file), "P");
    data_hour = [];
    for i = 0:(length(data_min.')/60 - 1)
        data_current_hour = data_min(1 + i*60: (i + 1)*60);
        data_current_hour_nan_removed = remove_nan(data_current_hour);
        if length(data_current_hour_nan_removed) == 0
        %choix de mettre la valeur à 0 car il vaut mieux sous estimer
        %notre production pour le dimensionement de nos batteries (on peut
        %toujours vendre le surplus de production à EDF)
        data_hour = [data_hour; 0];
        else
        data_hour = [data_hour; mean(data_current_hour_nan_removed.')];
        end
    end
end