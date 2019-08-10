function result = K(x, y)

a = abs(x-y);
b = (a/150)^2;
result = exp(double(-b));

end