-- ============================================
-- CA CCSS GRADE 6 MATHEMATICS - COMPLETE SEED DATA
-- California Common Core State Standards
-- ============================================
-- Run with: psql -h <host> -p <port> -U admin -d <database> -f seed_caccss_grade6.sql

-- ============================================
-- DOMAINS FOR GRADE 6 (5 Domains)
-- ============================================
-- Clear existing data first (for clean seed)
TRUNCATE TABLE topic_standards CASCADE;
TRUNCATE TABLE topics CASCADE;
TRUNCATE TABLE subjects CASCADE;
TRUNCATE TABLE standards CASCADE;
TRUNCATE TABLE clusters CASCADE;
TRUNCATE TABLE domains CASCADE;
TRUNCATE TABLE grades CASCADE;

-- Insert Grade 6
INSERT INTO grades (name, level, description) VALUES
    ('Grade 6', 6, 'California Common Core State Standards for Grade 6 Mathematics');

-- Insert 5 Domains for Grade 6
INSERT INTO domains (grade_id, name, code, description, order_index) VALUES
    (1, 'Ratios and Proportional Relationships', 'RP',
     'Understand ratio concepts and use ratio reasoning to solve problems', 1),
    (1, 'The Number System', 'NS',
     'Apply and extend previous understandings of multiplication and division to divide fractions by fractions; compute fluently with multi-digit numbers and find common factors and multiples; apply and extend previous understandings of numbers to the system of rational numbers', 2),
    (1, 'Expressions and Equations', 'EE',
     'Apply and extend previous understandings of arithmetic to algebraic expressions; reason about and solve one-variable equations and inequalities; represent and analyze quantitative relationships between dependent and independent variables', 3),
    (1, 'Geometry', 'G',
     'Solve real-world and mathematical problems involving area, surface area, and volume', 4),
    (1, 'Statistics and Probability', 'SP',
     'Develop understanding of statistical variability; summarize and describe distributions', 5);

-- ============================================
-- DOMAIN 1: RATIOS AND PROPORTIONAL RELATIONSHIPS (RP)
-- 1 Cluster, 6 Standards (including sub-standards)
-- ============================================

-- Cluster 1.1: Understand ratio concepts and use ratio reasoning to solve problems
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (1, 'Understand ratio concepts and use ratio reasoning to solve problems',
     'This cluster focuses on understanding ratios, unit rates, and using ratio reasoning to solve real-world problems. Students learn to make tables of equivalent ratios, solve unit rate problems, work with percentages, and convert measurement units.', 1);

-- Standards 6.RP.1 through 6.RP.3 (with sub-standards)
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (1, '6.RP.1',
     'Understand the concept of a ratio and use ratio language to describe a ratio relationship between two quantities. For example, "The ratio of wings to beaks in the bird house at the zoo was 2:1, because for every 2 wings there was 1 beak." "For every vote candidate A received, candidate C received nearly three votes."',
     'I can use ratio language to describe relationships between two quantities', TRUE, 1),
    (1, '6.RP.2',
     'Understand the concept of a unit rate a/b associated with a ratio a:b with b ≠ 0, and use rate language in the context of a ratio relationship. For example, "This recipe has a ratio of 3 cups of flour to 4 cups of sugar, so there is 3/4 cup of flour for each cup of sugar." "We paid $75 for 15 hamburgers, which is a rate of $5 per hamburger."',
     'I can understand unit rates and use rate language in ratio relationships', TRUE, 2),
    (1, '6.RP.3',
     'Use ratio and rate reasoning to solve real-world and mathematical problems, e.g., by reasoning about tables of equivalent ratios, tape diagrams, double number line diagrams, or equations.',
     'I can use ratio and rate reasoning to solve real-world and mathematical problems', TRUE, 3),
    (1, '6.RP.3.a',
     'Make tables of equivalent ratios relating quantities with whole-number measurements, find missing values in the tables, and plot the pairs of values on the coordinate plane. Use tables to compare ratios.',
     'I can make tables of equivalent ratios and plot them on the coordinate plane', TRUE, 4),
    (1, '6.RP.3.b',
     'Solve unit rate problems including those involving unit pricing and constant speed. For example, if it took 7 hours to mow 4 lawns, then at that rate, how many lawns could be mowed in 35 hours? At what rate were lawns being mowed?',
     'I can solve unit rate problems including unit pricing and constant speed', TRUE, 5),
    (1, '6.RP.3.c',
     'Find a percent of a quantity as a rate per 100 (e.g., 30% of a quantity means 30/100 times the quantity); solve problems involving finding the whole, given a part and the percent.',
     'I can find a percent of a quantity and solve percent problems', TRUE, 6),
    (1, '6.RP.3.d',
     'Use ratio reasoning to convert measurement units; manipulate and transform units appropriately when multiplying or dividing quantities.',
     'I can use ratio reasoning to convert between different measurement units', TRUE, 7);

-- ============================================
-- DOMAIN 2: THE NUMBER SYSTEM (NS)
-- 3 Clusters, 11 Standards (including sub-standards)
-- ============================================

-- Cluster 2.1: Apply and extend previous understandings of multiplication and division to divide fractions by fractions
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (2, 'Apply and extend previous understandings of multiplication and division to divide fractions by fractions',
     'Students extend their understanding of fraction division to include dividing fractions by fractions. They learn to interpret and compute quotients of fractions and solve word problems involving fraction division.', 1);

-- Cluster 2.2: Compute fluently with multi-digit numbers and find common factors and multiples
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (2, 'Compute fluently with multi-digit numbers and find common factors and multiples',
     'This cluster focuses on computational fluency with multi-digit whole numbers and decimals using standard algorithms. Students also find greatest common factors and least common multiples and use the distributive property.', 2);

-- Cluster 2.3: Apply and extend previous understandings of numbers to the system of rational numbers
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (2, 'Apply and extend previous understandings of numbers to the system of rational numbers',
     'Students develop understanding of positive and negative numbers, rational numbers as points on the number line, ordering and absolute value of rational numbers, and graphing in all four quadrants of the coordinate plane.', 3);

-- Standards for Cluster 2.1
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (2, '6.NS.1',
     'Interpret and compute quotients of fractions, and solve word problems involving division of fractions by fractions, e.g., by using visual fraction models and equations to represent the problem. For example, create a story context for (2/3) ÷ (3/4) and use a visual fraction model to show the quotient; use the relationship between multiplication and division to explain that (2/3) ÷ (3/4) = 8/9 because 3/4 of 8/9 is 2/3. (In general, (a/b) ÷ (c/d) = ad/bc.) How much chocolate will each person get if 3 people share 1/2 lb of chocolate equally? How many 3/4-cup servings are in 2/3 of a cup of yogurt? How wide is a rectangular strip of land with length 3/4 mi and area 1/2 square mi?',
     'I can divide fractions by fractions and solve word problems with fraction division', TRUE, 1);

-- Standards for Cluster 2.2
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (3, '6.NS.2',
     'Fluently divide multi-digit numbers using the standard algorithm.',
     'I can fluently divide multi-digit numbers using the standard algorithm', TRUE, 1),
    (3, '6.NS.3',
     'Fluently add, subtract, multiply, and divide multi-digit decimals using the standard algorithm for each operation.',
     'I can fluently add, subtract, multiply, and divide multi-digit decimals', TRUE, 2),
    (3, '6.NS.4',
     'Find the greatest common factor of two whole numbers less than or equal to 100 and the least common multiple of two whole numbers less than or equal to 12. Use the distributive property to express a sum of two whole numbers 1-100 with a common factor as a multiple of a sum of two whole numbers with no common factor. For example, express 36 + 8 as 4(9 + 2).',
     'I can find GCF and LCM and use the distributive property', FALSE, 3);

-- Standards for Cluster 2.3
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (4, '6.NS.5',
     'Understand that positive and negative numbers are used together to describe quantities having opposite directions or values (e.g., temperature above/below zero, elevation above/below sea level, credits/debits, positive/negative electric charge); use positive and negative numbers to represent quantities in real-world contexts, explaining the meaning of 0 in each situation.',
     'I can understand and use positive and negative numbers in real-world contexts', FALSE, 1),
    (4, '6.NS.6',
     'Understand a rational number as a point on the number line. Extend number line diagrams and coordinate axes familiar from previous grades to represent points on the line and in the plane with negative number coordinates.',
     'I can understand rational numbers as points on the number line and coordinate plane', FALSE, 2),
    (4, '6.NS.6.a',
     'Recognize opposite signs of numbers as indicating locations on opposite sides of 0 on the number line; recognize that the opposite of the opposite of a number is the number itself, e.g., -(-3) = 3, and that 0 is its own opposite.',
     'I can recognize opposite signs and understand that -(-a) = a', FALSE, 3),
    (4, '6.NS.6.b',
     'Understand signs of numbers in ordered pairs as indicating locations in quadrants of the coordinate plane; recognize that when two ordered pairs differ only by signs, the locations of the points are related by reflections across one or both axes.',
     'I can understand signs in ordered pairs and reflections across axes', FALSE, 4),
    (4, '6.NS.6.c',
     'Find and position integers and other rational numbers on a horizontal or vertical number line diagram; find and position pairs of integers and other rational numbers on a coordinate plane.',
     'I can position integers and rational numbers on number lines and coordinate planes', FALSE, 5),
    (4, '6.NS.7',
     'Understand ordering and absolute value of rational numbers.',
     'I can understand ordering and absolute value of rational numbers', FALSE, 6),
    (4, '6.NS.7.a',
     'Interpret statements of inequality as statements about the relative position of two numbers on a number line diagram. For example, interpret -3 > -7 as a statement that -3 is located to the right of -7 on a number line oriented from left to right.',
     'I can interpret inequalities as relative positions on a number line', FALSE, 7),
    (4, '6.NS.7.b',
     'Write, interpret, and explain statements of order for rational numbers in real-world contexts. For example, write -3°C > -7°C to express the fact that -3°C is warmer than -7°C.',
     'I can write and interpret statements of order in real-world contexts', FALSE, 8),
    (4, '6.NS.7.c',
     'Understand the absolute value of a rational number as its distance from 0 on the number line; interpret absolute value as magnitude for a positive or negative quantity in a real-world situation. For example, for an account balance of -30 dollars, write |-30| = 30 to describe the size of the debt in dollars.',
     'I can understand absolute value as distance from 0 and interpret magnitude', FALSE, 9),
    (4, '6.NS.7.d',
     'Distinguish comparisons of absolute value from statements about order. For example, recognize that an account balance less than -30 dollars represents a debt greater than 30 dollars.',
     'I can distinguish absolute value comparisons from order statements', FALSE, 10),
    (4, '6.NS.8',
     'Solve real-world and mathematical problems by graphing points in all four quadrants of the coordinate plane. Include use of coordinates and absolute value to find distances between points with the same first coordinate or the same second coordinate.',
     'I can solve problems by graphing points in all four quadrants and find distances', FALSE, 11);

-- ============================================
-- DOMAIN 3: EXPRESSIONS AND EQUATIONS (EE)
-- 3 Clusters, 10 Standards (including sub-standards)
-- ============================================

-- Cluster 3.1: Apply and extend previous understandings of arithmetic to algebraic expressions
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (3, 'Apply and extend previous understandings of arithmetic to algebraic expressions',
     'Students write and evaluate numerical expressions with exponents, work with algebraic expressions involving variables, identify parts of expressions, apply properties of operations to generate equivalent expressions, and identify when expressions are equivalent.', 1);

-- Cluster 3.2: Reason about and solve one-variable equations and inequalities
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (3, 'Reason about and solve one-variable equations and inequalities',
     'Students understand solving equations and inequalities as a process of finding values that make the equation or inequality true. They use variables to represent numbers, write and solve equations of specific forms, and write inequalities with infinitely many solutions.', 2);

-- Cluster 3.3: Represent and analyze quantitative relationships between dependent and independent variables
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (3, 'Represent and analyze quantitative relationships between dependent and independent variables',
     'Students use variables to represent quantities that change in relationship to one another, write equations expressing one quantity in terms of the other, and analyze relationships using graphs, tables, and equations.', 3);

-- Standards for Cluster 3.1
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (5, '6.EE.1',
     'Write and evaluate numerical expressions involving whole-number exponents.',
     'I can write and evaluate numerical expressions with exponents', TRUE, 1),
    (5, '6.EE.2',
     'Write, read, and evaluate expressions in which letters stand for numbers.',
     'I can write, read, and evaluate algebraic expressions', TRUE, 2),
    (5, '6.EE.2.a',
     'Write expressions that record operations with numbers and with letters standing for numbers. For example, express the calculation "Subtract y from 5" as 5 - y.',
     'I can write expressions using numbers and variables', TRUE, 3),
    (5, '6.EE.2.b',
     'Identify parts of an expression using mathematical terms (sum, term, product, factor, quotient, coefficient); view one or more parts of an expression as a single entity. For example, describe the expression 2(8 + 7) as a product of two factors; view (8 + 7) as both a single entity and a sum of two terms.',
     'I can identify parts of expressions using mathematical terms', TRUE, 4),
    (5, '6.EE.2.c',
     'Evaluate expressions at specific values of their variables. Include expressions that arise from formulas used in real-world problems. Perform arithmetic operations, including those involving whole-number exponents, in the conventional order when there are no parentheses to specify a particular order (Order of Operations). For example, use the formulas V = s³ and A = 6s² to find the volume and surface area of a cube with sides of length s = 1/2.',
     'I can evaluate expressions at specific values and use Order of Operations', TRUE, 5),
    (5, '6.EE.3',
     'Apply the properties of operations to generate equivalent expressions. For example, apply the distributive property to the expression 3(2 + x) to produce the equivalent expression 6 + 3x; apply the distributive property to the expression 24x + 18y to produce the equivalent expression 6(4x + 3y); apply properties of operations to y + y + y to produce the equivalent expression 3y.',
     'I can apply properties of operations to generate equivalent expressions', TRUE, 6),
    (5, '6.EE.4',
     'Identify when two expressions are equivalent (i.e., when the two expressions name the same number regardless of which value is substituted into them). For example, the expressions y + y + y and 3y are equivalent because they name the same number regardless of which number y stands for.',
     'I can identify when two expressions are equivalent', TRUE, 7);

-- Standards for Cluster 3.2
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (6, '6.EE.5',
     'Understand solving an equation or inequality as a process of answering a question: which values from a specified set, if any, make the equation or inequality true? Use substitution to determine whether a given number in a specified set makes an equation or inequality true.',
     'I can understand solving equations and inequalities as finding values that make them true', TRUE, 1),
    (6, '6.EE.6',
     'Use variables to represent numbers and write expressions when solving a real-world or mathematical problem; understand that a variable can represent an unknown number, or, depending on the purpose at hand, any number in a specified set.',
     'I can use variables to represent numbers in real-world problems', TRUE, 2),
    (6, '6.EE.7',
     'Solve real-world and mathematical problems by writing and solving equations of the form x + p = q and px = q for cases in which p, q and x are all nonnegative rational numbers.',
     'I can write and solve one-step equations with nonnegative rational numbers', TRUE, 3),
    (6, '6.EE.8',
     'Write an inequality of the form x > c or x < c to represent a constraint or condition in a real-world or mathematical problem. Recognize that inequalities of the form x > c or x < c have infinitely many solutions; represent solutions of such inequalities on number line diagrams.',
     'I can write inequalities and represent solutions on number lines', FALSE, 4);

-- Standards for Cluster 3.3
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (7, '6.EE.9',
     'Use variables to represent two quantities in a real-world problem that change in relationship to one another; write an equation to express one quantity, thought of as the dependent variable, in terms of the other quantity, thought of as the independent variable. Analyze the relationship between the dependent and independent variables using graphs and tables, and relate these to the equation. For example, in a problem involving motion at constant speed, list and graph ordered pairs of distances and times, and write the equation d = 65t to represent the relationship between distance and time.',
     'I can use variables to represent changing quantities and analyze relationships', TRUE, 1);

-- ============================================
-- DOMAIN 4: GEOMETRY (G)
-- 1 Cluster, 4 Standards
-- ============================================

-- Cluster 4.1: Solve real-world and mathematical problems involving area, surface area, and volume
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (4, 'Solve real-world and mathematical problems involving area, surface area, and volume',
     'Students find areas of triangles, quadrilaterals, and polygons; find volumes of right rectangular prisms with fractional edge lengths; draw polygons in the coordinate plane; and represent three-dimensional figures using nets to find surface area.', 1);

-- Standards for Geometry
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (8, '6.G.1',
     'Find the area of right triangles, other triangles, special quadrilaterals, and polygons by composing into rectangles or decomposing into triangles and other shapes; apply these techniques in the context of solving real-world and mathematical problems.',
     'I can find areas of triangles and polygons by composing and decomposing', TRUE, 1),
    (8, '6.G.2',
     'Find the volume of a right rectangular prism with fractional edge lengths by packing it with unit cubes of the appropriate unit fraction edge lengths, and show that the volume is the same as would be found by multiplying the edge lengths of the prism. Apply the formulas V = lwh and V = bh to find volumes of right rectangular prisms with fractional edge lengths in the context of solving real-world and mathematical problems.',
     'I can find volumes of right rectangular prisms with fractional edge lengths', TRUE, 2),
    (8, '6.G.3',
     'Draw polygons in the coordinate plane given coordinates for the vertices; use coordinates to find the length of a side joining points with the same first coordinate or the same second coordinate. Apply these techniques in the context of solving real-world and mathematical problems.',
     'I can draw polygons on the coordinate plane and find side lengths', TRUE, 3),
    (8, '6.G.4',
     'Represent three-dimensional figures using nets made up of rectangles and triangles, and use the nets to find the surface area of these figures. Apply these techniques in the context of solving real-world and mathematical problems.',
     'I can use nets to represent 3D figures and find surface area', TRUE, 4);

-- ============================================
-- DOMAIN 5: STATISTICS AND PROBABILITY (SP)
-- 2 Clusters, 7 Standards (including sub-standards)
-- ============================================

-- Cluster 5.1: Develop understanding of statistical variability
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (5, 'Develop understanding of statistical variability',
     'Students recognize statistical questions anticipate variability in the data, understand data distributions described by center, spread, and overall shape, and recognize measures of center and variation.', 1);

-- Cluster 5.2: Summarize and describe distributions
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (5, 'Summarize and describe distributions',
     'Students display numerical data in plots on a number line, summarize data sets in relation to their context including measures of center and variability, and relate choice of measures to the shape of the distribution.', 2);

-- Standards for Cluster 5.1
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (9, '6.SP.1',
     'Recognize a statistical question as one that anticipates variability in the data related to the question and accounts for it in the answers. For example, "How old am I?" is not a statistical question, but "How old are the students in my school?" is a statistical question because one anticipates variability in students'' ages.',
     'I can recognize statistical questions that anticipate variability', FALSE, 1),
    (9, '6.SP.2',
     'Understand that a set of data collected to answer a statistical question has a distribution which can be described by its center, spread, and overall shape.',
     'I can understand data distributions described by center, spread, and shape', FALSE, 2),
    (9, '6.SP.3',
     'Recognize that a measure of center for a numerical data set summarizes all of its values with a single number, while a measure of variation describes how its values vary with a single number.',
     'I can understand measures of center and variation', FALSE, 3);

-- Standards for Cluster 5.2
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (10, '6.SP.4',
     'Display numerical data in plots on a number line, including dot plots, histograms, and box plots.',
     'I can display numerical data using dot plots, histograms, and box plots', FALSE, 1),
    (10, '6.SP.5',
     'Summarize numerical data sets in relation to their context, such as by:',
     'I can summarize numerical data sets in relation to their context', FALSE, 2),
    (10, '6.SP.5.a',
     'Reporting the number of observations.',
     'I can report the number of observations in a data set', FALSE, 3),
    (10, '6.SP.5.b',
     'Describing the nature of the attribute under investigation, including how it was measured and its units of measurement.',
     'I can describe the nature of the attribute being measured', FALSE, 4),
    (10, '6.SP.5.c',
     'Giving quantitative measures of center (median and/or mean) and variability (interquartile range and/or mean absolute deviation), as well as describing any overall pattern and any striking deviations from the overall pattern with reference to the context in which the data were gathered.',
     'I can give measures of center and variability and describe patterns', FALSE, 5),
    (10, '6.SP.5.d',
     'Relating the choice of measures of center and variability to the shape of the data distribution and the context in which the data were gathered.',
     'I can relate choice of measures to the shape of the distribution', FALSE, 6);

-- ============================================
-- SUBJECT: MATHEMATICS FOR GRADE 6
-- ============================================
INSERT INTO subjects (grade_id, name, slug, description, icon, color_theme, order_index) VALUES
    (1, 'Mathematics', 'mathematics',
     'California Common Core State Standards for Grade 6 Mathematics covering Ratios and Proportional Relationships, The Number System, Expressions and Equations, Geometry, and Statistics and Probability',
     '📐', 'math', 1);

-- ============================================
-- TOPICS (Sample topics aligned to clusters)
-- ============================================
INSERT INTO topics (subject_id, name, slug, description, difficulty_level, estimated_minutes, prerequisites, order_index) VALUES
    -- RP Topics
    (1, 'Understanding Ratios', 'understanding-ratios',
     'Learn what ratios are and how to use ratio language to describe relationships between quantities', 1, 45, ARRAY[]::INTEGER[], 1),
    (1, 'Unit Rates', 'unit-rates',
     'Understand unit rates and use rate language to describe ratio relationships', 2, 60, ARRAY[1], 2),
    (1, 'Equivalent Ratios and Tables', 'equivalent-ratios',
     'Make tables of equivalent ratios and plot values on the coordinate plane', 2, 60, ARRAY[1], 3),
    (1, 'Solving Unit Rate Problems', 'solving-unit-rate-problems',
     'Solve real-world problems involving unit pricing and constant speed', 3, 75, ARRAY[2], 4),
    (1, 'Percent Problems', 'percent-problems',
     'Find a percent of a quantity and solve problems involving percents', 3, 75, ARRAY[3], 5),
    (1, 'Measurement Unit Conversions', 'measurement-conversions',
     'Use ratio reasoning to convert between different measurement units', 2, 45, ARRAY[3], 6),

    -- NS Topics
    (1, 'Dividing Fractions', 'dividing-fractions',
     'Divide fractions by fractions and solve word problems', 3, 90, ARRAY[]::INTEGER[], 7),
    (1, 'Multi-Digit Division', 'multi-digit-division',
     'Fluently divide multi-digit numbers using the standard algorithm', 2, 60, ARRAY[]::INTEGER[], 8),
    (1, 'Decimal Operations', 'decimal-operations',
     'Add, subtract, multiply, and divide multi-digit decimals', 2, 75, ARRAY[8], 9),
    (1, 'GCF and LCM', 'gcf-and-lcm',
     'Find greatest common factors and least common multiples', 2, 60, ARRAY[]::INTEGER[], 10),
    (1, 'Positive and Negative Numbers', 'positive-negative-numbers',
     'Understand positive and negative numbers in real-world contexts', 2, 60, ARRAY[]::INTEGER[], 11),
    (1, 'Rational Numbers on Number Lines', 'rational-number-lines',
     'Position integers and rational numbers on number lines and coordinate planes', 3, 75, ARRAY[11], 12),
    (1, 'Ordering and Absolute Value', 'ordering-absolute-value',
     'Understand ordering and absolute value of rational numbers', 3, 75, ARRAY[12], 13),
    (1, 'Distance on Coordinate Plane', 'coordinate-distance',
     'Solve problems using coordinates and find distances on the coordinate plane', 3, 75, ARRAY[12], 14),

    -- EE Topics
    (1, 'Exponents', 'exponents',
     'Write and evaluate numerical expressions with whole-number exponents', 2, 45, ARRAY[]::INTEGER[], 15),
    (1, 'Writing Expressions', 'writing-expressions',
     'Write and read expressions using variables to represent numbers', 2, 60, ARRAY[]::INTEGER[], 16),
    (1, 'Parts of Expressions', 'parts-of-expressions',
     'Identify parts of expressions using mathematical terms', 2, 45, ARRAY[16], 17),
    (1, 'Evaluating Expressions', 'evaluating-expressions',
     'Evaluate expressions at specific values using Order of Operations', 3, 75, ARRAY[15, 16], 18),
    (1, 'Equivalent Expressions', 'equivalent-expressions',
     'Apply properties of operations to generate equivalent expressions', 3, 75, ARRAY[16], 19),
    (1, 'Solving Equations', 'solving-equations',
     'Understand and solve one-variable equations', 3, 90, ARRAY[16], 20),
    (1, 'Writing Equations from Word Problems', 'equations-word-problems',
     'Use variables to represent numbers and write equations for real-world problems', 3, 75, ARRAY[20], 21),
    (1, 'One-Step Equations', 'one-step-equations',
     'Solve one-step equations with nonnegative rational numbers', 3, 75, ARRAY[20], 22),
    (1, 'Inequalities', 'inequalities',
     'Write inequalities and represent solutions on number lines', 3, 60, ARRAY[20], 23),
    (1, 'Dependent and Independent Variables', 'dependent-independent-variables',
     'Analyze relationships between dependent and independent variables', 3, 90, ARRAY[20], 24),

    -- G Topics
    (1, 'Area of Triangles', 'area-of-triangles',
     'Find areas of triangles by composing and decomposing shapes', 2, 60, ARRAY[]::INTEGER[], 25),
    (1, 'Area of Quadrilaterals', 'area-of-quadrilaterals',
     'Find areas of special quadrilaterals and polygons', 3, 75, ARRAY[25], 26),
    (1, 'Volume of Rectangular Prisms', 'volume-prisms',
     'Find volumes of right rectangular prisms with fractional edge lengths', 3, 75, ARRAY[9], 27),
    (1, 'Polygons on Coordinate Plane', 'polygons-coordinate-plane',
     'Draw polygons and find side lengths on the coordinate plane', 3, 75, ARRAY[12], 28),
    (1, 'Nets and Surface Area', 'nets-surface-area',
     'Use nets to represent 3D figures and find surface area', 3, 90, ARRAY[26], 29),

    -- SP Topics
    (1, 'Statistical Questions', 'statistical-questions',
     'Recognize statistical questions and understand variability', 1, 45, ARRAY[]::INTEGER[], 30),
    (1, 'Data Distributions', 'data-distributions',
     'Understand data distributions described by center, spread, and shape', 2, 60, ARRAY[30], 31),
    (1, 'Measures of Center and Variation', 'measures-center-variation',
     'Understand measures of center and variation', 2, 60, ARRAY[31], 32),
    (1, 'Displaying Data', 'displaying-data',
     'Display numerical data using dot plots, histograms, and box plots', 2, 75, ARRAY[31], 33),
    (1, 'Summarizing Data Sets', 'summarizing-data',
     'Summarize numerical data sets in relation to their context', 3, 90, ARRAY[32, 33], 34);

-- ============================================
-- TOPIC-STANDARDS LINKS (which standards each topic covers)
-- ============================================
-- RP Topic-Standards
INSERT INTO topic_standards (topic_id, standard_id, coverage_level, priority) VALUES
    (1, 1, 'develop', 1),    -- Understanding Ratios -> 6.RP.1
    (2, 2, 'master', 1),     -- Unit Rates -> 6.RP.2
    (3, 3, 'develop', 1),    -- Equivalent Ratios -> 6.RP.3
    (3, 4, 'develop', 2),    -- Equivalent Ratios -> 6.RP.3.a
    (4, 5, 'master', 1),     -- Solving Unit Rate Problems -> 6.RP.3.b
    (5, 6, 'master', 1),     -- Percent Problems -> 6.RP.3.c
    (6, 7, 'develop', 1),    -- Measurement Conversions -> 6.RP.3.d

    -- NS Topic-Standards
    (7, 8, 'master', 1),       -- Dividing Fractions -> 6.NS.1
    (8, 9, 'develop', 1),    -- Multi-Digit Division -> 6.NS.2
    (9, 10, 'develop', 1),   -- Decimal Operations -> 6.NS.3
    (10, 11, 'develop', 1),  -- GCF and LCM -> 6.NS.4
    (11, 12, 'introduce', 1), -- Positive/Negative Numbers -> 6.NS.5
    (12, 13, 'develop', 1),  -- Rational Numbers -> 6.NS.6
    (12, 15, 'develop', 2),  -- Rational Numbers -> 6.NS.6.b
    (12, 16, 'master', 3),   -- Rational Numbers -> 6.NS.6.c
    (13, 17, 'develop', 1),  -- Ordering/Absolute Value -> 6.NS.7
    (13, 20, 'develop', 2),  -- Ordering/Absolute Value -> 6.NS.7.c
    (14, 22, 'master', 1),   -- Coordinate Distance -> 6.NS.8

    -- EE Topic-Standards
    (15, 23, 'introduce', 1), -- Exponents -> 6.EE.1
    (16, 24, 'develop', 1),  -- Writing Expressions -> 6.EE.2
    (16, 25, 'develop', 2),  -- Writing Expressions -> 6.EE.2.a
    (17, 26, 'develop', 1),  -- Parts of Expressions -> 6.EE.2.b
    (18, 27, 'master', 1),   -- Evaluating Expressions -> 6.EE.2.c
    (19, 28, 'develop', 1),  -- Equivalent Expressions -> 6.EE.3
    (19, 29, 'develop', 2),  -- Equivalent Expressions -> 6.EE.4
    (20, 30, 'develop', 1),  -- Solving Equations -> 6.EE.5
    (21, 31, 'develop', 1),  -- Equations Word Problems -> 6.EE.6
    (22, 32, 'master', 1),   -- One-Step Equations -> 6.EE.7
    (23, 33, 'develop', 1),  -- Inequalities -> 6.EE.8
    (24, 34, 'master', 1),   -- Dependent/Independent Variables -> 6.EE.9

    -- G Topic-Standards
    (25, 35, 'develop', 1),  -- Area of Triangles -> 6.G.1
    (26, 35, 'master', 1),   -- Area of Quadrilaterals -> 6.G.1
    (27, 36, 'master', 1),   -- Volume of Prisms -> 6.G.2
    (28, 37, 'develop', 1),  -- Polygons on Coordinate Plane -> 6.G.3
    (29, 38, 'master', 1),   -- Nets and Surface Area -> 6.G.4

    -- SP Topic-Standards
    (30, 39, 'introduce', 1), -- Statistical Questions -> 6.SP.1
    (31, 40, 'develop', 1),  -- Data Distributions -> 6.SP.2
    (32, 41, 'develop', 1),  -- Measures Center/Variation -> 6.SP.3
    (33, 42, 'master', 1),   -- Displaying Data -> 6.SP.4
    (34, 43, 'develop', 1),  -- Summarizing Data -> 6.SP.5
    (34, 44, 'develop', 2),  -- Summarizing Data -> 6.SP.5.a
    (34, 45, 'develop', 3),  -- Summarizing Data -> 6.SP.5.c
    (34, 46, 'develop', 4);  -- Summarizing Data -> 6.SP.5.d

-- ============================================
-- VERIFICATION QUERY
-- ============================================
SELECT
    '=== CA CCSS Grade 6 Seed Data Summary ===' AS report;

SELECT
    'Grades: ' || COUNT(*)::TEXT FROM grades
UNION ALL
SELECT
    'Domains: ' || COUNT(*)::TEXT FROM domains
UNION ALL
SELECT
    'Clusters: ' || COUNT(*)::TEXT FROM clusters
UNION ALL
SELECT
    'Standards: ' || COUNT(*)::TEXT FROM standards
UNION ALL
SELECT
    'Subjects: ' || COUNT(*)::TEXT FROM subjects
UNION ALL
SELECT
    'Topics: ' || COUNT(*)::TEXT FROM topics
UNION ALL
SELECT
    'Topic-Standards Links: ' || COUNT(*)::TEXT FROM topic_standards;

SELECT
    '=== Seed Data Complete ===' AS status;
