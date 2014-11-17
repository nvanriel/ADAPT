function [val, chi2] = proflik(model, pName, frac, alpha)

import AMF.*

[~, sse] = fit(model);

p = model.ref.(pName);
p.fit = 0;
parseParameters(model);

popt = p.curr;

val(1) = popt;
chi2(1) = sse;

ref = chi2pdf(1-alpha, 1);

rat = -inf;
ctr = 2;
while rat <= ref
    p.curr = popt * (1+frac*(ctr-1)); disp(p.curr);
    [~, sse] = fit(model);
    val = [val p.curr];
    chi2 = [chi2 sse];
    
    rat = 2 * log10(sse / chi2(1)); % ???
    ctr = ctr + 1;
end

rat = -inf;
ctr = 2;
while rat <= ref
    p.curr = popt * (1-frac*(ctr-1)); disp(p.curr);
    [~, sse] = fit(model);
    val = [val p.curr];
    chi2 = [chi2 sse];
    
    rat = 2 * log(sse / chi2(1)); % ???
    ctr = ctr + 1;
end

p.fit = 1;
parseParameters(model);

[val, idx] = sort(val);
chi2 = chi2(idx);

% display
figure;
plot(val, chi2, 'r');
hold on;
[~, idx] = min(chi2);
plot(val(idx), chi2(idx), 'kx', 'MarkerSize', 10, 'LineWidth', 2);

xlabel(p.name);
ylabel('chi2');