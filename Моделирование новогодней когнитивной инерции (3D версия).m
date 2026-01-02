%% Моделирование новогодней когнитивной инерции (3D версия)
% Автор: [Ваше имя]
% Дата: 2 января 2026
% MATLAB R2025+

clear all; close all; clc;

%% Параметры эксперимента
days_before = 15;     % дней до Нового года
days_after = 45;      % дней после Нового года
total_days = days_before + days_after + 1;

% Временная ось (дни относительно НГ)
days = -days_before:days_after;

%% Усложненная модель с несколькими альфа
alphas = [0.85, 0.90, 0.93, 0.96, 0.98];  % Разные типы мышления
alpha_labels = {'Быстрая адаптация', 'Сбалансированный', 'Средний', ...
                'Консервативный', 'Макс. инерция'};

% Цветовая схема
colors = [0.2, 0.6, 1.0;    % голубой
          0.9, 0.4, 0.1;    % оранжевый
          0.3, 0.8, 0.3;    % зеленый
          0.8, 0.2, 0.8;    % фиолетовый
          1.0, 0.1, 0.1];   % красный

%% Модель реальности
real_year = zeros(1, total_days);
real_year(days <= 0) = 2025;
real_year(days > 0)  = 2026;

%% Подготовка данных для 3D
[X, Y] = meshgrid(days, 1:length(alphas));
Z = zeros(size(X));

%% Симуляция для разных альфа
brain_data = cell(1, length(alphas));
for a_idx = 1:length(alphas)
    alpha = alphas(a_idx);
    brain_year = zeros(1, total_days);
    brain_year(1) = 2025;
    
    % Основное уравнение
    for i = 2:total_days
        brain_year(i) = alpha * brain_year(i-1) + (1 - alpha) * real_year(i);
    end
    
    brain_data{a_idx} = brain_year;
    Z(a_idx, :) = brain_year;
    
    % Добавляем случайный шум для реалистичности (упрощенная модель)
    if a_idx == 3  % Для "среднего" типа
        noise = 0.01 * randn(1, total_days);
        Z(a_idx, :) = Z(a_idx, :) + noise;
    end
end

%% 3D Визуализация
figure('Position', [100, 100, 1200, 700], 'Color', 'white');

% 3D поверхность
subplot(2,3,[1,2,4,5]);
hold on; grid on; box on;

surf(X, Y, Z, 'EdgeAlpha', 0.3, 'FaceAlpha', 0.8);
colormap(jet);

% Контурные линии на поверхности
for a_idx = 1:length(alphas)
    plot3(days, a_idx*ones(size(days)), brain_data{a_idx}, ...
          'Color', colors(a_idx,:), 'LineWidth', 2.5);
end

% Вертикальная плоскость - момент Нового года
[Y_plane, Z_plane] = meshgrid(1:length(alphas), 2024:0.1:2026);
X_plane = zeros(size(Y_plane));
surf(X_plane, Y_plane, Z_plane, 'FaceColor', [0.5,0.5,0.5], ...
     'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Настройки 3D графика
xlabel('Дни относительно НГ', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Тип мышления (α)', 'FontSize', 11, 'FontWeight', 'bold');
zlabel('Ожидаемый год', 'FontSize', 11, 'FontWeight', 'bold');
title('3D Модель когнитивной инерции', 'FontSize', 13, 'FontWeight', 'bold');
view(45, 30);  % Угол обзора

% Легенда для типов мышления
for a_idx = 1:length(alphas)
    plot3(NaN, NaN, NaN, 'Color', colors(a_idx,:), 'LineWidth', 3, ...
          'DisplayName', sprintf('%s (α=%.2f)', alpha_labels{a_idx}, alphas(a_idx)));
end
legend('Location', 'northeast', 'FontSize', 9);

%% Дополнительные 2D проекции
% Вид сверху (контурная карта)
subplot(2,3,3);
contourf(X, Y, Z, 20, 'LineColor', 'none');
colormap(subplot(2,3,3), hot);
colorbar;
xlabel('Дни относительно НГ');
ylabel('Тип мышления');
title('Карта изохрон адаптации');
grid on;
xline(0, 'w--', 'LineWidth', 1.5);
yticks(1:length(alphas));
yticklabels(cellfun(@(x) sprintf('%.2f', x), num2cell(alphas), 'UniformOutput', false));

% Боковая проекция (X-Z плоскость)
subplot(2,3,6);
hold on; grid on; box on;
for a_idx = 1:length(alphas)
    plot(days, brain_data{a_idx}, 'Color', colors(a_idx,:), ...
         'LineWidth', 2, 'DisplayName', sprintf('α=%.2f', alphas(a_idx)));
end
plot(days, real_year, 'k--', 'LineWidth', 3, 'DisplayName', 'Реальность');
xlabel('Дни относительно НГ');
ylabel('Год');
title('Проекция X-Z');
legend('Location', 'southeast', 'FontSize', 8);
xline(0, 'k-', 'LineWidth', 1);

%% Анимация адаптации для среднего типа (α=0.93)
figure('Position', [150, 150, 800, 400], 'Color', 'white');
mid_alpha_idx = 3;
brain_mid = brain_data{mid_alpha_idx};

for day_idx = 1:5:total_days
    clf;
    hold on; grid on; box on;
    
    % График до текущего дня
    plot(days(1:day_idx), brain_mid(1:day_idx), 'b-', 'LineWidth', 3);
    plot(days(1:day_idx), real_year(1:day_idx), 'r--', 'LineWidth', 2);
    
    % Текущая точка
    plot(days(day_idx), brain_mid(day_idx), 'bo', ...
         'MarkerSize', 12, 'MarkerFaceColor', 'b');
    plot(days(day_idx), real_year(day_idx), 'ro', ...
         'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    % Настройки
    xlabel('Дни относительно НГ');
    ylabel('Год');
    title(sprintf('День %+d: Мозг = %.3f, Реальность = %d', ...
          days(day_idx), brain_mid(day_idx), real_year(day_idx)));
    legend('Мозг (α=0.93)', 'Реальность', 'Location', 'southeast');
    xlim([-days_before, days_after]);
    ylim([2024.8, 2026.2]);
    
    % Вертикальная линия Нового года
    xline(0, 'k-', 'LineWidth', 1);
    
    % Прогресс-бар адаптации
    progress = (brain_mid(day_idx) - 2025) / (2026 - 2025) * 100;
    if days(day_idx) >= 0
        annotation('rectangle', [0.2, 0.05, progress/100*0.6, 0.03], ...
                   'FaceColor', 'g', 'EdgeColor', 'k');
        text(0.5, 0.02, sprintf('Адаптация: %.1f%%', progress), ...
             'Units', 'normalized', 'HorizontalAlignment', 'center');
    end
    
    drawnow;
    pause(0.1);
end

%% Расчет и вывод статистики
fprintf('\n=== СРАВНИТЕЛЬНАЯ СТАТИСТИКА ===\n');
fprintf('%-25s %-12s %-15s %-10s\n', 'Тип мышления', 'α', 'Время до 99% (дни)', 'τ (дни)');
fprintf('%s\n', repmat('-', 1, 65));

for a_idx = 1:length(alphas)
    alpha_val = alphas(a_idx);
    brain_curve = brain_data{a_idx};
    
    % Время достижения 99% адаптации
    idx_99 = find(brain_curve >= 2025.99, 1);
    if ~isempty(idx_99)
        days_to_99 = days(idx_99);
    else
        days_to_99 = Inf;
    end
    
    % Постоянная времени
    tau = -1 / log(alpha_val);
    
    fprintf('%-25s %-12.3f %-15d %-10.1f\n', ...
            alpha_labels{a_idx}(1:min(25, length(alpha_labels{a_idx}))), ...
            alpha_val, days_to_99, tau);
end

% Расчет "оптимального" α (адаптация за 10 дней)
target_days = 10;
optimal_alpha = exp(-1/target_days);
fprintf('\nОптимальный α для адаптации за %d дней: %.3f\n', ...
        target_days, optimal_alpha);
fprintf('%s\n', repmat('=', 1, 65));