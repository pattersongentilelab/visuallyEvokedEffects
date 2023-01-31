function y_data_boot = calc95Boot(y_data,stat)
    
    switch stat
        case 1
            bootval = sort(bootstrp(1000,@nanmean,y_data));
        case 2
            bootval = sort(bootstrp(1000,@nanmedian,y_data));
    end
    y_data_boot=bootval([25 500 975],:);

end
