function [sol,info] = prox_sum_log(x, gamma, param)
%PROX_SUM_LOG Proximal operator of log-barrier  - sum(log(x))
%   Usage:  sol = prox_sum_log(x, gamma)
%           sol = prox_sum_log(x, gamma, param)
%           [sol, info] = prox_sum_log(x, gamma, param)
%
%   Input parameters:
%         x     : Input signal.
%         gamma : Regularization parameter.
%         param : Structure of optional parameters.
%   Output parameters:
%         sol   : Solution.
%         info : Structure summarizing informations at convergence
%
%   `prox_l1(x, gamma, param)` solves:
%
%   .. sol = argmin_{z} 0.5*||x - z||_2^2 - gamma * sum(log(z))
%
%   .. math::  sol = \min_{z} \frac{1}{2} \|x - z\|_2^2 - \gamma \sum_i(log(z_i))
%
%   param is a Matlab structure containing the following fields:
%
%   * *param.verbose* : 0 no log, 1 a summary at convergence
%
%   info is a Matlab structure containing the following fields:
%
%   * *info.algo* : Algorithm used
%
%   * *info.iter* : Number of iteration
%
%   * *info.time* : Time of exectution of the function in sec.
%
%   * *info.final_eval* : Final evaluation of the function
%
%   * *info.crit* : Stopping critterion used 
%
%
%   See also:  prox_l1 prox_l2 prox_tv
%
%   References:

% Author: Vassilis Kalofolias
% Date: June 2015
% Testing: test_prox_sum_log

% Start the time counter
t1 = tic;

if nargin < 3, param = struct; end

if ~isfield(param, 'verbose'), param.verbose = 1; end


if any(x(:) <= 0)
    % TODO: check validity
    warning('prox_sum_log:   Negative input. Proximal still defined (and positive) but log itself is not!');
end
stop_error = 0;

% if any(x(:) <= 0)
%     warning('prox_sum_log:   Trying to find proximal for logarithm of negative numbers! ABORTING.');
%     stop_error = 1;
% else
%     stop_error = 0;
% end


% test the parameters
stop_error = stop_error | test_gamma(gamma);

if stop_error
    sol = x;
    info.algo = mfilename;
    info.iter = 0;
    info.final_eval = 0;
    info.crit = '--';
    info.time = toc(t1);
    return
end



sol = (x + sqrt(x.^2 + 4*gamma)) /2;
info.algo = mfilename;
info.iter = 0;
info.final_eval = gamma * sum(log(x(:)));
info.crit = '--';
info.time = toc(t1);
    
% Log after the prox
if param.verbose >= 1
    fprintf('  prox_sum_log: sum(log(x)) = %e\n', info.final_eval);
end

end

