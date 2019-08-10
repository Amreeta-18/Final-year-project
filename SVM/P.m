function result = P(mean, var, data)


a = 1 / sqrt(2*3.14*var);
b = (data-mean)^2;
c = b/(2*var);
d = exp(double(-c));
result = a*d;

end