function readout = get_value_roi(roi, R)
% get roi (readout of interest) value 
% the mean is taken over all iterations and specified time_span
iters = length(R);
time_span_pts = roi.time_span(2)-roi.time_span(1);

readout = 0;
for i = 1:iters
    roi_temp = 0;
    for j = 1:length(roi.index)
       roi_temp = sum(R(i).(roi.type)(roi.index(j),roi.time_span));
       roi_temp = roi_temp / (time_span_pts);
    end
    readout = readout +  roi_temp;
end
readout = readout / iters;

end

