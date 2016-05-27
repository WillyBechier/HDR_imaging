%% Graph Translation example
%
% We show here how the graph translation is constructed and how it compares
% to two different time shift like operators, namely the generalised
% translations and the graph shift.

%% Example graph
%
% We use a graph of $100$ vertices randomly drawn in a 2D square of size
% 10x10 using the uniform distribution.

g = plane_rnd(100);
show_graph(gca, g, 'show_edges', false);
colorbar;

%%
% Add edges between vertices at distance less than $3$. Weight the edges
% by a Gaussian kernel $a_{ij}=exp(-\frac{d(i,j)^2}{2\sigma^2})$ with
% $\sigma^2=1/1.5$. Note that graph_adjacency_thresh thresholds the weights
% on the edges, and not the distances.

g.A = graph_adjacency_gaussian(g, 1/1.5);
g.A = graph_adjacency_thresh(g, exp(-3 * 3 ^ 2));
show_graph(gca, g, 'show_edges', true);
colorbar;

%%
% Create the Fourier transform.

g = graph_eigendecomposition(g);

%%
% Create the translation operators.

TG = graph_translation(g);
T1 = graph_generalised_translation(g, 1);
GS = g.A;

%% Example graph signal: delta
% Translate a delta signal to study the impulse response.

d10 = graph_delta(g, 10);
show_graph(gca, g, 'node_values', abs(d10), 'value_scale', [0 1]);
colorbar;
title('|\delta_{10}|');
snapnow;
show_graph(gca, g, 'node_values', abs(TG * d10), 'value_scale', [0 1]);
colorbar;
title('|T_g \delta_{10}|');
snapnow;
show_graph(gca, g, 'node_values', abs(T1 * d10), 'value_scale', [0 max(abs(T1 * d10))], 'highlight_nodes', 1);
colorbar;
title('|T_1 \delta_{10}|');
snapnow;
show_graph(gca, g, 'node_values', abs(GS * d10), 'value_scale', [0 1]);
colorbar;
title('|A \delta_{10}|');
snapnow;

%% 
% Iterate the graph translation and the graph shift.
% We observe the saturation of the color scale for the graph shift due to
% the non-isometry of this operator.

kmax = 100;
translated_gt(100, kmax + 1) = 0;
translated_gs(100, kmax + 1) = 0;
for k = 0:kmax
    translated_gt(:, k + 1) = TG ^ k * d10;
    translated_gs(:, k + 1) = GS ^ k * d10;
end
mod_options = struct('value_scale', [0 1], 'color_map', 'jet');
ang_options = struct('value_scale', [-pi pi], 'color_map', 'hsv');
gs_options = struct('value_scale', [0 1], 'color_map', 'jet');
titles_mod = arrayfun(@(k) ['|T_g^{' int2str(k) '} d_{10}|'], 0:kmax, 'UniformOutput', false);
titles_ang = arrayfun(@(k) ['\angle(T_g^{' int2str(k) '} d_{10})'], 0:kmax, 'UniformOutput', false);
titles_gs = arrayfun(@(k) ['|A^{' int2str(k) '} d_{10}|'], 0:kmax, 'UniformOutput', false);
graph_generate_gif(gcf, 'html/tg_d10_mod_anim.gif', g, abs(translated_gt), titles_mod, mod_options);
graph_generate_gif(gcf, 'html/tg_d10_ang_anim.gif', g, angle(translated_gt), titles_ang, ang_options);
graph_generate_gif(gcf, 'html/gs_d10_anim.gif', g, abs(translated_gs), titles_gs, gs_options);
close;

%%
%
% <html>
% <img vspace="5" hspace="5" src="tg_d10_mod_anim.gif" />
% <img vspace="5" hspace="5" src="tg_d10_ang_anim.gif" />
% </html>
%
%%
%
% <html>
% <img vspace="5" hspace="5" src="gs_d10_anim.gif" />
% </html>

%%
% Normalized output for the graph shift

for k = 0:kmax
    translated_gs(:, k + 1) = translated_gs(:, k + 1) / norm(translated_gs(:, k + 1));
end
titles_gs = arrayfun(@(k) ['|A^{' int2str(k) '} d_{10}| / ||A^{' int2str(k) '} d_{10}||_2'], 0:kmax, 'UniformOutput', false);
cla(gca);
graph_generate_gif(gcf, 'html/gs_d10_norm_anim.gif', g, abs(translated_gs), titles_gs, gs_options);
close;

%%
%
% <html>
% <img vspace="5" hspace="5" src="gs_d10_norm_anim.gif" />
% </html>

%% Example graph signal: heat kernel
% As defined in [Shuman, Ricaud, Vandergheynst 2015], $X$ is a heat kernel
% defined as $\widehat{X}(l)=Cexp(-10\lambda_l)$, with $\|X\|_2 = 1$.

cla(gca);
X = graph_heat_kernel(g, 10);
X = X / norm(X);
show_graph(gca, g, 'node_values', abs(X));
colorbar;
title('|X|');

%%
% Translate X.

show_graph(gca, g, 'node_values', abs(TG * X), 'value_scale', [0 max(abs(TG * X))]);
colorbar;
title('|T_g X|');
snapnow;

show_graph(gca, g, 'node_values', abs(T1 * X), 'value_scale', [0 max(abs(T1 * X))], 'highlight_nodes', 1);
colorbar;
title('|T_1 X|');
snapnow;

show_graph(gca, g, 'node_values', abs(GS * X), 'value_scale', [0 max(abs(GS * X))]);
colorbar;
title('|A X|');
snapnow;

%% 
% Iterate the graph translation and the graph shift on the signal X.
% The output of the graph shift is normalised.

kmax = 100;
translated_gt(100, kmax + 1) = 0;
translated_gs(100, kmax + 1) = 0;
for k = 0:kmax
    translated_gt(:, k + 1) = TG ^ k * X;
    tmp = GS ^ k * X;
    translated_gs(:, k + 1) = tmp / norm(tmp);
end
mod_options = struct('value_scale', [0 max(abs(translated_gt(:)))], 'color_map', 'jet');
ang_options = struct('value_scale', [-pi pi], 'color_map', 'hsv');
gs_options = struct('value_scale', [0 max(abs(translated_gs(:)))], 'color_map', 'jet');
titles_mod = arrayfun(@(k) ['|T_g^{' int2str(k) '} X|'], 0:kmax, 'UniformOutput', false);
titles_ang = arrayfun(@(k) ['\angle(T_g^{' int2str(k) '} X)'], 0:kmax, 'UniformOutput', false);
titles_gs = arrayfun(@(k) ['|A^{' int2str(k) '} X| / ||A^{' int2str(k) '} X||_2'], 0:kmax, 'UniformOutput', false);
graph_generate_gif(gcf, 'html/tg_X_mod_anim.gif', g, abs(translated_gt), titles_mod, mod_options);
graph_generate_gif(gcf, 'html/tg_X_ang_anim.gif', g, angle(translated_gt), titles_ang, ang_options);
graph_generate_gif(gcf, 'html/gs_X_norm_anim.gif', g, abs(translated_gs), titles_gs, gs_options);
close;

%%
%
% <html>
% <img vspace="5" hspace="5" src="tg_X_mod_anim.gif" />
% <img vspace="5" hspace="5" src="tg_X_ang_anim.gif" />
% </html>
%
%%
%
% <html>
% <img vspace="5" hspace="5" src="gs_X_norm_anim.gif" />
% </html>
