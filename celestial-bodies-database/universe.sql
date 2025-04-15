CREATE DATABASE universe;

\c universe

CREATE TABLE galaxy (
    galaxy_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    age_in_millions_of_years INT NOT NULL,
    distance_from_earth_light_years NUMERIC(10, 2),
    has_supermassive_black_hole BOOLEAN DEFAULT TRUE
);

CREATE TABLE star (
    star_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    galaxy_id INT NOT NULL,
    star_type TEXT,
    is_spherical BOOLEAN DEFAULT TRUE NOT NULL,
    temperature_kelvin INT,
    FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
);

CREATE TABLE planet (
    planet_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    star_id INT NOT NULL,
    planet_type TEXT,
    has_atmosphere BOOLEAN DEFAULT FALSE NOT NULL,
    orbital_period_days NUMERIC(12, 4),
    number_of_moons INT DEFAULT 0,
    FOREIGN KEY (star_id) REFERENCES star(star_id)
);

CREATE TABLE moon (
    moon_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    planet_id INT NOT NULL,
    is_tidally_locked BOOLEAN DEFAULT TRUE NOT NULL,
    discovery_year INT,
    surface_gravity_g NUMERIC(6, 3),
    FOREIGN KEY (planet_id) REFERENCES planet(planet_id)
);

CREATE TABLE asteroid_belt (
    asteroid_belt_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    galaxy_id INT NOT NULL,
    main_composition TEXT,
    estimated_mass_kg NUMERIC(20, 2),
    contains_water_ice BOOLEAN DEFAULT FALSE NOT NULL,
    FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
);

INSERT INTO galaxy (name, description, age_in_millions_of_years, distance_from_earth_light_years, has_supermassive_black_hole) VALUES
('Milky Way', 'Our home galaxy, a barred spiral galaxy.', 13600, 0.00, TRUE),
('Andromeda', 'Nearest large spiral galaxy to the Milky Way.', 10000, 2537000.00, TRUE),
('Triangulum', 'Third-largest member of the Local Group.', 13000, 3000000.00, FALSE),
('Messier 87', 'Supergiant elliptical galaxy in the constellation Virgo.', 6000, 53500000.00, TRUE),
('Whirlpool Galaxy', 'Interacting grand-design spiral galaxy.', 400, 23000000.00, TRUE),
('Sombrero Galaxy', 'Unbarred spiral galaxy in the constellation Virgo.', 9000, 29350000.00, TRUE);

INSERT INTO star (name, galaxy_id, star_type, is_spherical, temperature_kelvin) VALUES
('Sun', 1, 'G-type main-sequence (G2V)', TRUE, 5778),
('Proxima Centauri', 1, 'M-type red dwarf (M5.5Ve)', TRUE, 3042),
('Sirius A', 1, 'A-type main-sequence (A1V)', TRUE, 9940),
('Betelgeuse', 1, 'M-type red supergiant (M1-M2Ia-Iab)', FALSE, 3500),
('Alpha Andromedae', 2, 'B-type subgiant (B8IVpMnHg)', TRUE, 13000),
('VY Canis Majoris', 1, 'M-type hypergiant (M3-M4.5)', FALSE, 3490);

INSERT INTO planet (name, star_id, planet_type, has_atmosphere, orbital_period_days, number_of_moons) VALUES
('Mercury', 1, 'Terrestrial', FALSE, 87.97, 0),
('Venus', 1, 'Terrestrial', TRUE, 224.70, 0),
('Earth', 1, 'Terrestrial', TRUE, 365.25, 1),
('Mars', 1, 'Terrestrial', TRUE, 687.00, 2),
('Jupiter', 1, 'Gas Giant', TRUE, 4332.59, 95),
('Saturn', 1, 'Gas Giant', TRUE, 10759.22, 146),
('Uranus', 1, 'Ice Giant', TRUE, 30688.50, 27),
('Neptune', 1, 'Ice Giant', TRUE, 60182.00, 14),
('Proxima Centauri b', 2, 'Terrestrial', TRUE, 11.186, 0),
('Proxima Centauri d', 2, 'Sub-Earth', FALSE, 5.122, 0),
('Sirius b', 3, 'White Dwarf', FALSE, 18250.00, 0),
('Kepler-186f', 1, 'Terrestrial', TRUE, 129.9, 0);

INSERT INTO moon (name, planet_id, is_tidally_locked, discovery_year, surface_gravity_g) VALUES
('Moon', 3, TRUE, NULL, 0.165),
('Phobos', 4, TRUE, 1877, 0.00058),
('Deimos', 4, TRUE, 1877, 0.00031),
('Io', 5, TRUE, 1610, 0.183),
('Europa', 5, TRUE, 1610, 0.134),
('Ganymede', 5, TRUE, 1610, 0.146),
('Callisto', 5, TRUE, 1610, 0.126),
('Amalthea', 5, TRUE, 1892, 0.002),
('Himalia', 5, FALSE, 1904, 0.006),
('Thebe', 5, TRUE, 1979, 0.004),
('Mimas', 6, TRUE, 1789, 0.006),
('Enceladus', 6, TRUE, 1789, 0.011),
('Tethys', 6, TRUE, 1684, 0.015),
('Dione', 6, TRUE, 1684, 0.024),
('Rhea', 6, TRUE, 1672, 0.027),
('Titan', 6, TRUE, 1655, 0.138),
('Iapetus', 6, TRUE, 1671, 0.023),
('Ariel', 7, TRUE, 1851, 0.027),
('Umbriel', 7, TRUE, 1851, 0.020),
('Titania', 7, TRUE, 1787, 0.039),
('Oberon', 7, TRUE, 1787, 0.035),
('Triton', 8, TRUE, 1846, 0.079);

INSERT INTO asteroid_belt (name, galaxy_id, main_composition, estimated_mass_kg, contains_water_ice) VALUES
('Main Asteroid Belt', 1, 'Silicates and Metals', 3.0E21, TRUE),
('Kuiper Belt', 1, 'Ices (Water, Methane, Ammonia)', 1.0E22, TRUE),
('Scattered Disc', 1, 'Icy Bodies', 1.0E22, TRUE);
