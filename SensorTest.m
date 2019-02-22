obstacle = wallObject(2, 2, 7, 7);
sensor = PerfectObservationSensor(obstacle, 0.1, pi/8, 3);

sensor.detect(0, 0, pi/4)
