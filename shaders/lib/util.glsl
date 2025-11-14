vec3 projectAndDivide(mat4 projectionMatrix, vec3 position) {
    vec4 homPos = projectionMatrix * vec4(position, 1.0);
    return homPos.xyz / homPos.w;
}

// Returns 0.0 at midnight, 1.0 at noon, and a linear interpolation in between.
// Parameter currentTime can be obtained from the worldTime uniform.
float getTimeLerpFactor(int currentTime) {
	const int HALFWAY_TIME =  12000;
	const int PEAK_OFFSET  = -6000;
	const int TIME_MAX     =  24000;
	
	int offsetTime = (currentTime + PEAK_OFFSET + TIME_MAX) % TIME_MAX;
	float factor = abs(HALFWAY_TIME - offsetTime) / float(HALFWAY_TIME);
	return clamp(factor, 0.0, 1.0);
}
