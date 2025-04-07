function constantVar = createParallelConstant(val)
    % Wraps a given value into a parallel.pool.Constant
    constantVar = parallel.pool.Constant(val);
end

