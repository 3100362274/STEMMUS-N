classdef FunctionsContainer
    methods (Static)
        function res = func1(a)
            res = a * 5;
        end

        function res = func2(x)
            res = x .^ 2;
        end
    end
end