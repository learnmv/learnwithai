-- =============================================================================
-- COMPLETE CA CCSS 6TH GRADE MATHEMATICS SEED DATA
-- California Common Core State Standards - Full Standards Set
-- =============================================================================
-- Run this after database_schema.sql to populate all tables
-- Source: California Department of Education Mathematics Framework
-- =============================================================================

-- ============================================
-- 6TH GRADE DOMAINS (All 5 Domains)
-- ============================================
INSERT INTO domains (grade_id, name, code, description, order_index) VALUES
    (1, 'Ratios and Proportional Relationships', 'RP',
     'Understand ratio concepts and use ratio reasoning to solve problems', 1),
    (1, 'The Number System', 'NS',
     'Apply and extend previous understandings of multiplication and division to divide fractions by fractions, compute fluently with multi-digit numbers, and apply understandings to rational numbers', 2),
    (1, 'Expressions and Equations', 'EE',
     'Apply and extend previous understandings of arithmetic to algebraic expressions, reason about and solve one-variable equations and inequalities, and represent quantitative relationships', 3),
    (1, 'Geometry', 'G',
     'Solve real-world and mathematical problems involving area, surface area, and volume', 4),
    (1, 'Statistics and Probability', 'SP',
     'Develop understanding of statistical variability and summarize and describe distributions', 5);

-- ============================================
-- CLUSTERS
-- ============================================

-- Domain RP Clusters (1 cluster)
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (1, 'Understand ratio concepts and use ratio reasoning to solve problems',
     'Students understand the concept of a ratio as a way of expressing relationships between two quantities. They use ratio language to describe these relationships and apply ratio reasoning to solve real-world and mathematical problems including percents and unit conversion.', 1);

-- Domain NS Clusters (3 clusters)
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (2, 'Apply and extend previous understandings of multiplication and division to divide fractions by fractions',
     'Students interpret and compute quotients of fractions and solve word problems involving division of fractions by fractions using visual models and equations.', 1),
    (2, 'Compute fluently with multi-digit numbers and find common factors and multiples',
     'Students fluently divide multi-digit numbers and perform operations with multi-digit decimals using standard algorithms. They find greatest common factors and least common multiples.', 2),
    (2, 'Apply and extend previous understandings of numbers to the system of rational numbers',
     'Students understand that positive and negative numbers describe quantities with opposite directions or values. They work with rational numbers on number lines and coordinate planes, understand ordering and absolute value.', 3);

-- Domain EE Clusters (3 clusters)
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (3, 'Apply and extend previous understandings of arithmetic to algebraic expressions',
     'Students write and evaluate numerical expressions with whole-number exponents. They write expressions with variables, identify parts of expressions, apply properties of operations, and identify equivalent expressions.', 1),
    (3, 'Reason about and solve one-variable equations and inequalities',
     'Students understand solving equations and inequalities as finding values that make them true. They use variables to represent numbers, solve real-world problems with equations, and write and graph inequalities.', 2),
    (3, 'Represent and analyze quantitative relationships between dependent and independent variables',
     'Students use variables to represent quantities that change in relationship to one another. They write equations expressing dependent variables in terms of independent variables and analyze relationships using graphs, tables, and equations.', 3);

-- Domain G Clusters (1 cluster)
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (4, 'Solve real-world and mathematical problems involving area, surface area, and volume',
     'Students find areas of polygons by composing into rectangles or decomposing into triangles. They find volumes of right rectangular prisms with fractional edge lengths, draw polygons in the coordinate plane, and find surface area using nets.', 1);

-- Domain SP Clusters (2 clusters)
INSERT INTO clusters (domain_id, name, description, order_index) VALUES
    (5, 'Develop understanding of statistical variability',
     'Students recognize that statistical questions anticipate variability in data. They understand that data sets have distributions described by center, spread, and overall shape, and recognize measures of center and variation.', 1),
    (5, 'Summarize and describe distributions',
     'Students display numerical data in plots on a number line. They summarize data sets by reporting observations, describing attributes, giving quantitative measures of center and variability, and relating these choices to the context.', 2);

-- ============================================
-- STANDARDS - Domain RP (Ratios & Proportional Relationships)
-- Cluster: Understand ratio concepts and use ratio reasoning to solve problems
-- ============================================
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (1, '6.RP.1',
     'Understand the concept of a ratio and use ratio language to describe a ratio relationship between two quantities. For example, "The ratio of wings to beaks in the bird house at the zoo was 2:1, because for every 2 wings there was 1 beak." "For every vote candidate A received, candidate C received nearly three votes."',
     'I can use ratio language to describe relationships between two quantities', TRUE, 1),

    (1, '6.RP.2',
     'Understand the concept of a unit rate a/b associated with a ratio a:b with b ≠ 0, and use rate language in the context of a ratio relationship. For example, "This recipe has a ratio of 3 cups of flour to 4 cups of sugar, so there is 3/4 cup of flour for each cup of sugar." "We paid $75 for 15 hamburgers, which is a rate of $5 per hamburger."',
     'I can understand unit rates and use rate language to describe ratio relationships', TRUE, 2),

    (1, '6.RP.3',
     'Use ratio and rate reasoning to solve real-world and mathematical problems, e.g., by reasoning about tables of equivalent ratios, tape diagrams, double number line diagrams, or equations.',
     'I can use ratios and rates to solve real-world and mathematical problems', TRUE, 3),

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
     'I can use ratio reasoning to convert measurement units', TRUE, 7);

-- ============================================
-- STANDARDS - Domain NS (The Number System)
-- Cluster: Apply and extend previous understandings of multiplication and division to divide fractions by fractions
-- ============================================
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (2, '6.NS.1',
     'Interpret and compute quotients of fractions, and solve word problems involving division of fractions by fractions, e.g., by using visual fraction models and equations to represent the problem. For example, create a story context for (2/3) ÷ (3/4) and use a visual fraction model to show the quotient; use the relationship between multiplication and division to explain that (2/3) ÷ (3/4) = 8/9 because 3/4 of 8/9 is 2/3. (In general, (a/b) ÷ (c/d) = ad/bc.) How much chocolate will each person get if 3 people share 1/2 lb of chocolate equally? How many 3/4-cup servings are in 2/3 cups of yogurt? How wide is a rectangular strip of land with length 3/4 mi and area 1/2 square mi?',
     'I can divide fractions by fractions and solve word problems using visual models', TRUE, 1);

-- Cluster: Compute fluently with multi-digit numbers and find common factors and multiples
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (3, '6.NS.2',
     'Fluently divide multi-digit numbers using the standard algorithm.',
     'I can fluently divide multi-digit numbers using the standard algorithm', FALSE, 2),

    (3, '6.NS.3',
     'Fluently add, subtract, multiply, and divide multi-digit decimals using the standard algorithm for each operation.',
     'I can fluently add, subtract, multiply, and divide multi-digit decimals', FALSE, 3),

    (3, '6.NS.4',
     'Find the greatest common factor of two whole numbers less than or equal to 100 and the least common multiple of two whole numbers less than or equal to 12. Use the distributive property to express a sum of two whole numbers 1-100 with a common factor as a multiple of a sum of two whole numbers with no common factor. For example, express 36 + 8 as 4 (9 + 2).',
     'I can find GCF and LCM and use the distributive property with factors', FALSE, 4);

-- Cluster: Apply and extend previous understandings of numbers to the system of rational numbers
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (4, '6.NS.5',
     'Understand that positive and negative numbers are used together to describe quantities having opposite directions or values (e.g., temperature above/below zero, elevation above/below sea level, credits/debits, positive/negative electric charge); use positive and negative numbers to represent quantities in real-world contexts, explaining the meaning of 0 in each situation.',
     'I can understand and use positive and negative numbers in real-world contexts', FALSE, 5),

    (4, '6.NS.6',
     'Understand a rational number as a point on the number line. Extend number line diagrams and coordinate axes familiar from previous grades to represent points on the line and in the plane with negative number coordinates.',
     'I can understand rational numbers as points on the number line and coordinate plane', FALSE, 6),

    (4, '6.NS.6.a',
     'Recognize opposite signs of numbers as indicating locations on opposite sides of 0 on the number line; recognize that the opposite of the opposite of a number is the number itself, e.g., –(–3) = 3, and that 0 is its own opposite.',
     'I can recognize opposite signs and that the opposite of the opposite is the number itself', FALSE, 7),

    (4, '6.NS.6.b',
     'Understand signs of numbers in ordered pairs as indicating locations in quadrants of the coordinate plane; recognize that when two ordered pairs differ only by signs, the locations of the points are related by reflections across one or both axes.',
     'I can understand signs in ordered pairs and reflections across axes', FALSE, 8),

    (4, '6.NS.6.c',
     'Find and position integers and other rational numbers on a horizontal or vertical number line diagram; find and position pairs of integers and other rational numbers on a coordinate plane.',
     'I can position integers and rational numbers on number lines and coordinate planes', FALSE, 9),

    (4, '6.NS.7',
     'Understand ordering and absolute value of rational numbers.',
     'I can understand ordering and absolute value of rational numbers', FALSE, 10),

    (4, '6.NS.7.a',
     'Interpret statements of inequality as statements about the relative position of two numbers on a number line diagram. For example, interpret –3 > –7 as a statement that –3 is located to the right of –7 on a number line oriented from left to right.',
     'I can interpret inequality statements using the number line', FALSE, 11),

    (4, '6.NS.7.b',
     'Write, interpret, and explain statements of order for rational numbers in real-world contexts. For example, write –3 °C > –7 °C to express the fact that –3 °C is warmer than –7 °C.',
     'I can write and interpret inequalities in real-world contexts', FALSE, 12),

    (4, '6.NS.7.c',
     'Understand the absolute value of a rational number as its distance from 0 on the number line; interpret absolute value as magnitude for a positive or negative quantity in a real-world situation. For example, for an account balance of –30 dollars, write |–30| = 30 to describe the size of the debt in dollars.',
     'I can understand absolute value as distance from 0 and magnitude in real-world situations', FALSE, 13),

    (4, '6.NS.7.d',
     'Distinguish comparisons of absolute value from statements about order. For example, recognize that an account balance less than –30 dollars represents a debt greater than 30 dollars.',
     'I can distinguish comparisons of absolute value from statements about order', FALSE, 14),

    (4, '6.NS.8',
     'Solve real-world and mathematical problems by graphing points in all four quadrants of the coordinate plane. Include use of coordinates and absolute value to find distances between points with the same first coordinate or the same second coordinate.',
     'I can solve problems by graphing points and finding distances on the coordinate plane', FALSE, 15);

-- ============================================
-- STANDARDS - Domain EE (Expressions & Equations)
-- Cluster: Apply and extend previous understandings of arithmetic to algebraic expressions
-- ============================================
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (5, '6.EE.1',
     'Write and evaluate numerical expressions involving whole-number exponents.',
     'I can write and evaluate expressions with whole-number exponents', FALSE, 1),

    (5, '6.EE.2',
     'Write, read, and evaluate expressions in which letters stand for numbers.',
     'I can write, read, and evaluate expressions with variables', FALSE, 2),

    (5, '6.EE.2.a',
     'Write expressions that record operations with numbers and with letters standing for numbers. For example, express the calculation "Subtract y from 5" as 5 – y.',
     'I can write expressions using variables to represent numbers', FALSE, 3),

    (5, '6.EE.2.b',
     'Identify parts of an expression using mathematical terms (sum, term, product, factor, quotient, coefficient); view one or more parts of an expression as a single entity. For example, describe the expression 2 (8 + 7) as a product of two factors; view (8 + 7) as both a single entity and a sum of two terms.',
     'I can identify parts of expressions using mathematical terms', FALSE, 4),

    (5, '6.EE.2.c',
     'Evaluate expressions at specific values of their variables. Include expressions that arise from formulas used in real-world problems. Perform arithmetic operations, including those involving whole-number exponents, in the conventional order when there are no parentheses to specify a particular order (Order of Operations). For example, use the formulas V = s³ and A = 6s² to find the volume and surface area of a cube with sides of length s = 1/2.',
     'I can evaluate expressions at specific values following order of operations', FALSE, 5),

    (5, '6.EE.3',
     'Apply the properties of operations to generate equivalent expressions. For example, apply the distributive property to the expression 3 (2 + x) to produce the equivalent expression 6 + 3x; apply the distributive property to the expression 24x + 18y to produce the equivalent expression 6 (4x + 3y); apply properties of operations to y + y + y to produce the equivalent expression 3y.',
     'I can apply properties of operations to generate equivalent expressions', FALSE, 6),

    (5, '6.EE.4',
     'Identify when two expressions are equivalent (i.e., when the two expressions name the same number regardless of which value is substituted into them). For example, the expressions y + y + y and 3y are equivalent because they name the same number regardless of which number y stands for.',
     'I can identify when two expressions are equivalent', FALSE, 7);

-- Cluster: Reason about and solve one-variable equations and inequalities
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (6, '6.EE.5',
     'Understand solving an equation or inequality as a process of answering a question: which values from a specified set, if any, make the equation or inequality true? Use substitution to determine whether a given number in a specified set makes an equation or inequality true.',
     'I can understand solving equations and inequalities as finding values that make them true', FALSE, 8),

    (6, '6.EE.6',
     'Use variables to represent numbers and write expressions when solving a real-world or mathematical problem; understand that a variable can represent an unknown number, or, depending on the purpose at hand, any number in a specified set.',
     'I can use variables to represent numbers in real-world problems', FALSE, 9),

    (6, '6.EE.7',
     'Solve real-world and mathematical problems by writing and solving equations of the form x + p = q and px = q for cases in which p, q and x are all nonnegative rational numbers.',
     'I can solve equations of the form x + p = q and px = q', FALSE, 10),

    (6, '6.EE.8',
     'Write an inequality of the form x > c or x < c to represent a constraint or condition in a real-world or mathematical problem. Recognize that inequalities of the form x > c or x < c have infinitely many solutions; represent solutions of such inequalities on number line diagrams.',
     'I can write and graph inequalities on number lines', FALSE, 11);

-- Cluster: Represent and analyze quantitative relationships between dependent and independent variables
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (7, '6.EE.9',
     'Use variables to represent two quantities in a real-world problem that change in relationship to one another; write an equation to express one quantity, thought of as the dependent variable, in terms of the other quantity, thought of as the independent variable. Analyze the relationship between the dependent and independent variables using graphs and tables, and relate these to the equation. For example, in a problem involving motion at constant speed, list and graph ordered pairs of distances and times, and write the equation d = 65t to represent the relationship between distance and time.',
     'I can use variables to represent quantities that change in relationship and analyze using graphs, tables, and equations', FALSE, 12);

-- ============================================
-- STANDARDS - Domain G (Geometry)
-- Cluster: Solve real-world and mathematical problems involving area, surface area, and volume
-- ============================================
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (8, '6.G.1',
     'Find the area of right triangles, other triangles, special quadrilaterals, and polygons by composing into rectangles or decomposing into triangles and other shapes; apply these techniques in the context of solving real-world and mathematical problems.',
     'I can find the area of triangles and polygons by composing or decomposing shapes', FALSE, 1),

    (8, '6.G.2',
     'Find the volume of a right rectangular prism with fractional edge lengths by packing it with unit cubes of the appropriate unit fraction edge lengths, and show that the volume is the same as would be found by multiplying the edge lengths of the prism. Apply the formulas V = lwh and V = bh to find volumes of right rectangular prisms with fractional edge lengths in the context of solving real-world and mathematical problems.',
     'I can find the volume of right rectangular prisms with fractional edge lengths', FALSE, 2),

    (8, '6.G.3',
     'Draw polygons in the coordinate plane given coordinates for the vertices; use coordinates to find the length of a side joining points with the same first coordinate or the same second coordinate. Apply these techniques in the context of solving real-world and mathematical problems.',
     'I can draw polygons on the coordinate plane and find side lengths', FALSE, 3),

    (8, '6.G.4',
     'Represent three-dimensional figures using nets made up of rectangles and triangles, and use the nets to find the surface area of these figures. Apply these techniques in the context of solving real-world and mathematical problems.',
     'I can represent 3D figures using nets and find surface area', FALSE, 4);

-- ============================================
-- STANDARDS - Domain SP (Statistics & Probability)
-- Cluster: Develop understanding of statistical variability
-- ============================================
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (9, '6.SP.1',
     'Recognize a statistical question as one that anticipates variability in the data related to the question and accounts for it in the answers. For example, "How old am I?" is not a statistical question, but "How old are the students in my school?" is a statistical question because one anticipates variability in students'' ages.',
     'I can recognize statistical questions that anticipate variability in data', FALSE, 1),

    (9, '6.SP.2',
     'Understand that a set of data collected to answer a statistical question has a distribution which can be described by its center, spread, and overall shape.',
     'I can understand data distributions by their center, spread, and shape', FALSE, 2),

    (9, '6.SP.3',
     'Recognize that a measure of center for a numerical data set summarizes all of its values with a single number, while a measure of variation describes how its values vary with a single number.',
     'I can recognize that measures of center summarize data while measures of variation describe spread', FALSE, 3);

-- Cluster: Summarize and describe distributions
INSERT INTO standards (cluster_id, standard_code, description, learning_objective, is_major_work, order_index) VALUES
    (10, '6.SP.4',
     'Display numerical data in plots on a number line, including dot plots, histograms, and box plots.',
     'I can display numerical data using dot plots, histograms, and box plots', FALSE, 4),

    (10, '6.SP.5',
     'Summarize numerical data sets in relation to their context, such as by:',
     'I can summarize numerical data sets in relation to their context', FALSE, 5),

    (10, '6.SP.5.a',
     'Reporting the number of observations.',
     'I can report the number of observations in a data set', FALSE, 6),

    (10, '6.SP.5.b',
     'Describing the nature of the attribute under investigation, including how it was measured and its units of measurement.',
     'I can describe the nature of the attribute under investigation', FALSE, 7),

    (10, '6.SP.5.c',
     'Giving quantitative measures of center (median and/or mean) and variability (interquartile range and/or mean absolute deviation), as well as describing any overall pattern and any striking deviations from the overall pattern with reference to the context in which the data were gathered.',
     'I can give measures of center and variability and describe patterns in data', FALSE, 8),

    (10, '6.SP.5.d',
     'Relating the choice of measures of center and variability to the shape of the data distribution and the context in which the data were gathered.',
     'I can relate the choice of measures to the shape of the data distribution', FALSE, 9);

-- ============================================
-- SUBJECTS
-- ============================================
INSERT INTO subjects (grade_id, name, slug, description, icon, color_theme, order_index) VALUES
    (1, 'Mathematics', 'mathematics-6',
     'California Common Core State Standards for 6th Grade Mathematics - Ratios, number system, expressions, geometry, and statistics',
     '📐', 'math', 1);

-- ============================================
-- TOPICS - Based on standards groupings
-- ============================================
INSERT INTO topics (subject_id, name, slug, description, difficulty_level, estimated_minutes, order_index) VALUES
    -- RP Domain Topics
    (1, 'Introduction to Ratios', 'intro-to-ratios',
     'Learn what ratios are and how to use ratio language to describe relationships between quantities. Understand how ratios compare two quantities.', 1, 45, 1),

    (1, 'Unit Rates', 'unit-rates',
     'Understand unit rates and rate language. Learn to describe relationships using unit rates like dollars per item or miles per hour.', 2, 60, 2),

    (1, 'Ratio Tables and Graphing', 'ratio-tables-graphing',
     'Create tables of equivalent ratios, find missing values, and plot ratio pairs on the coordinate plane. Use tables to compare ratios.', 2, 60, 3),

    (1, 'Solving Rate Problems', 'solving-rate-problems',
     'Solve unit rate problems involving constant speed, unit pricing, and other real-world applications using ratio reasoning.', 3, 75, 4),

    (1, 'Percent Problems', 'percent-problems',
     'Understand percent as a rate per 100. Find a percent of a quantity and solve problems involving finding the whole given a part and percent.', 2, 60, 5),

    (1, 'Measurement Conversion', 'measurement-conversion',
     'Use ratio reasoning to convert between measurement units. Manipulate and transform units when multiplying or dividing.', 2, 45, 6),

    -- NS Domain Topics
    (1, 'Dividing Fractions', 'dividing-fractions',
     'Divide fractions by fractions using visual models and equations. Interpret quotients and solve word problems.', 3, 75, 7),

    (1, 'Multi-Digit Division', 'multi-digit-division',
     'Fluently divide multi-digit numbers using the standard algorithm.', 2, 60, 8),

    (1, 'Decimal Operations', 'decimal-operations',
     'Fluently add, subtract, multiply, and divide multi-digit decimals using standard algorithms.', 2, 60, 9),

    (1, 'GCF and LCM', 'gcf-and-lcm',
     'Find the greatest common factor and least common multiple. Use the distributive property to express sums with common factors.', 2, 60, 10),

    (1, 'Positive and Negative Numbers', 'positive-negative-numbers',
     'Understand positive and negative numbers. Use them to describe quantities with opposite values like temperature and elevation.', 2, 60, 11),

    (1, 'Rational Numbers on Number Lines', 'rational-numbers-number-lines',
     'Understand rational numbers as points on the number line. Recognize opposite signs and position integers on number lines.', 2, 60, 12),

    (1, 'Coordinate Plane', 'coordinate-plane',
     'Understand signs in ordered pairs. Find and position integers and rational numbers on the coordinate plane in all four quadrants.', 2, 60, 13),

    (1, 'Ordering and Absolute Value', 'ordering-absolute-value',
     'Understand ordering of rational numbers and absolute value as distance from zero. Interpret absolute value in real-world situations.', 2, 60, 14),

    (1, 'Distance on Coordinate Plane', 'distance-coordinate-plane',
     'Solve problems by graphing points in all four quadrants. Use coordinates and absolute value to find distances between points.', 3, 75, 15),

    -- EE Domain Topics
    (1, 'Numerical Expressions with Exponents', 'numerical-expressions-exponents',
     'Write and evaluate numerical expressions involving whole-number exponents.', 2, 45, 16),

    (1, 'Expressions with Variables', 'expressions-with-variables',
     'Write, read, and evaluate expressions in which letters stand for numbers. Use variables to represent unknowns.', 2, 60, 17),

    (1, 'Parts of Expressions', 'parts-of-expressions',
     'Identify parts of expressions using mathematical terms like sum, term, product, factor, quotient, and coefficient.', 2, 45, 18),

    (1, 'Order of Operations', 'order-of-operations',
     'Evaluate expressions at specific values following the conventional order of operations. Apply to real-world formulas.', 3, 75, 19),

    (1, 'Equivalent Expressions', 'equivalent-expressions',
     'Apply properties of operations to generate equivalent expressions. Identify when two expressions are equivalent.', 3, 75, 20),

    (1, 'Understanding Equations', 'understanding-equations',
     'Understand solving equations as finding values that make them true. Use substitution to check solutions.', 2, 60, 21),

    (1, 'Writing Equations', 'writing-equations',
     'Use variables to represent numbers and write expressions and equations when solving real-world problems.', 2, 60, 22),

    (1, 'Solving One-Step Equations', 'solving-one-step-equations',
     'Solve real-world problems by writing and solving equations of the form x + p = q and px = q with nonnegative rational numbers.', 3, 75, 23),

    (1, 'Inequalities', 'inequalities',
     'Write inequalities of the form x > c or x < c. Recognize infinitely many solutions and represent them on number lines.', 3, 60, 24),

    (1, 'Dependent and Independent Variables', 'dependent-independent-variables',
     'Use variables to represent quantities that change in relationship. Write equations and analyze using graphs and tables.', 3, 90, 25),

    -- G Domain Topics
    (1, 'Area of Triangles and Polygons', 'area-triangles-polygons',
     'Find the area of triangles and polygons by composing into rectangles or decomposing into triangles and other shapes.', 3, 75, 26),

    (1, 'Volume of Rectangular Prisms', 'volume-rectangular-prisms',
     'Find the volume of right rectangular prisms with fractional edge lengths. Apply formulas V = lwh and V = bh.', 3, 75, 27),

    (1, 'Polygons on Coordinate Plane', 'polygons-coordinate-plane',
     'Draw polygons in the coordinate plane given vertex coordinates. Use coordinates to find side lengths.', 3, 60, 28),

    (1, 'Nets and Surface Area', 'nets-surface-area',
     'Represent three-dimensional figures using nets made of rectangles and triangles. Use nets to find surface area.', 3, 90, 29),

    -- SP Domain Topics
    (1, 'Statistical Questions', 'statistical-questions',
     'Recognize statistical questions that anticipate variability in data versus questions with single answers.', 1, 45, 30),

    (1, 'Data Distributions', 'data-distributions',
     'Understand that data sets have distributions described by center, spread, and overall shape.', 2, 60, 31),

    (1, 'Measures of Center and Variation', 'measures-center-variation',
     'Recognize that measures of center summarize data with a single number, while measures of variation describe spread.', 2, 60, 32),

    (1, 'Displaying Numerical Data', 'displaying-numerical-data',
     'Display numerical data in plots on a number line including dot plots, histograms, and box plots.', 3, 75, 33),

    (1, 'Summarizing Data Sets', 'summarizing-data-sets',
     'Summarize numerical data sets by reporting observations, describing attributes, and giving measures of center and variability.', 3, 90, 34);

-- ============================================
-- TOPIC-STANDARDS LINKS
-- Connect topics to the standards they cover
-- ============================================
INSERT INTO topic_standards (topic_id, standard_id, coverage_level, priority) VALUES
    -- RP Topics
    (1, 1, 'introduce', 1),      -- Intro to Ratios -> 6.RP.1
    (2, 2, 'develop', 1),        -- Unit Rates -> 6.RP.2
    (3, 4, 'develop', 1),        -- Ratio Tables -> 6.RP.3.a
    (3, 1, 'develop', 2),        -- Ratio Tables -> 6.RP.1 (reinforce)
    (4, 5, 'master', 1),         -- Rate Problems -> 6.RP.3.b
    (4, 2, 'develop', 2),        -- Rate Problems -> 6.RP.2
    (5, 6, 'master', 1),         -- Percent -> 6.RP.3.c
    (6, 7, 'develop', 1),        -- Measurement -> 6.RP.3.d

    -- NS Topics
    (7, 8, 'master', 1),         -- Dividing Fractions -> 6.NS.1
    (8, 9, 'develop', 1),        -- Multi-digit Division -> 6.NS.2
    (9, 10, 'develop', 1),       -- Decimal Operations -> 6.NS.3
    (10, 11, 'develop', 1),      -- GCF/LCM -> 6.NS.4
    (11, 12, 'introduce', 1),    -- Positive/Negative -> 6.NS.5
    (12, 14, 'develop', 1),      -- Rational on Number Lines -> 6.NS.6.c
    (12, 13, 'develop', 2),      -- Rational on Number Lines -> 6.NS.6.a
    (13, 14, 'develop', 1),      -- Coordinate Plane -> 6.NS.6.c
    (13, 15, 'develop', 2),      -- Coordinate Plane -> 6.NS.6
    (14, 17, 'develop', 1),      -- Ordering/Absolute Value -> 6.NS.7.c
    (14, 16, 'develop', 2),      -- Ordering/Absolute Value -> 6.NS.7
    (15, 22, 'master', 1),       -- Distance on Plane -> 6.NS.8
    (15, 14, 'develop', 2),      -- Distance on Plane -> 6.NS.6.c

    -- EE Topics
    (16, 23, 'introduce', 1),    -- Numerical Expressions -> 6.EE.1
    (17, 24, 'introduce', 1),     -- Expressions with Variables -> 6.EE.2
    (17, 25, 'develop', 2),       -- Expressions with Variables -> 6.EE.2.a
    (18, 26, 'develop', 1),       -- Parts of Expressions -> 6.EE.2.b
    (19, 27, 'master', 1),        -- Order of Operations -> 6.EE.2.c
    (19, 23, 'develop', 2),        -- Order of Operations -> 6.EE.1
    (20, 28, 'develop', 1),        -- Equivalent Expressions -> 6.EE.3
    (20, 29, 'develop', 2),        -- Equivalent Expressions -> 6.EE.4
    (21, 30, 'introduce', 1),      -- Understanding Equations -> 6.EE.5
    (22, 31, 'develop', 1),        -- Writing Equations -> 6.EE.6
    (23, 32, 'master', 1),         -- Solving Equations -> 6.EE.7
    (23, 30, 'develop', 2),        -- Solving Equations -> 6.EE.5
    (24, 33, 'develop', 1),        -- Inequalities -> 6.EE.8
    (25, 34, 'master', 1),         -- Variables -> 6.EE.9

    -- G Topics
    (26, 35, 'master', 1),         -- Area -> 6.G.1
    (27, 36, 'master', 1),         -- Volume -> 6.G.2
    (28, 37, 'develop', 1),        -- Polygons on Plane -> 6.G.3
    (28, 22, 'develop', 2),        -- Polygons on Plane -> 6.NS.8
    (29, 38, 'master', 1),         -- Nets/Surface Area -> 6.G.4

    -- SP Topics
    (30, 39, 'introduce', 1),      -- Statistical Questions -> 6.SP.1
    (31, 40, 'introduce', 1),      -- Data Distributions -> 6.SP.2
    (32, 41, 'introduce', 1),      -- Measures Center/Variation -> 6.SP.3
    (33, 42, 'develop', 1),         -- Displaying Data -> 6.SP.4
    (34, 43, 'master', 1),          -- Summarizing Data -> 6.SP.5
    (34, 45, 'develop', 2),         -- Summarizing Data -> 6.SP.5.c
    (34, 46, 'develop', 3);        -- Summarizing Data -> 6.SP.5.d

-- ============================================
-- SUMMARY
-- ============================================
-- DOMAINS: 5 (RP, NS, EE, G, SP)
-- CLUSTERS: 10 total
-- STANDARDS: 46 total
-- SUBJECTS: 1 (Mathematics for Grade 6)
-- TOPICS: 34 comprehensive learning units
-- TOPIC-STANDARDS LINKS: 52 mappings
-- ============================================

SELECT 'CA CCSS 6th Grade Seed Data Loaded Successfully!' AS status;
SELECT 'Summary: 5 Domains, 10 Clusters, 46 Standards, 34 Topics' AS summary;
