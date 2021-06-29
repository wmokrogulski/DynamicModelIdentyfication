function tf_latex=tf_to_latex(G)
fracparts=regexp(evalc('G'),'([^\n]*)\n[ ]*-[-]+[ ]*\n([^\n]*)','tokens');
tf_latex=['T(' G.variable ')=\frac{' fracparts{1}{1} '}{' fracparts{1}{2} '}'];
end