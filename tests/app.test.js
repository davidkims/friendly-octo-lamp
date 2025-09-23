const request = require('supertest');
const app = require('../src/app');

describe('Friendly Octo Lamp API', () => {
    describe('GET /', () => {
        it('should return welcome message', async () => {
            const response = await request(app)
                .get('/')
                .expect(200);
            
            expect(response.body).toHaveProperty('message');
            expect(response.body).toHaveProperty('version');
            expect(response.body).toHaveProperty('timestamp');
            expect(response.body.message).toBe('Welcome to Friendly Octo Lamp!');
        });
    });

    describe('GET /health', () => {
        it('should return health status', async () => {
            const response = await request(app)
                .get('/health')
                .expect(200);
            
            expect(response.body).toHaveProperty('status');
            expect(response.body).toHaveProperty('uptime');
            expect(response.body).toHaveProperty('timestamp');
            expect(response.body.status).toBe('healthy');
        });
    });

    describe('GET /info', () => {
        it('should return system information', async () => {
            const response = await request(app)
                .get('/info')
                .expect(200);
            
            expect(response.body).toHaveProperty('application');
            expect(response.body).toHaveProperty('version');
            expect(response.body).toHaveProperty('node_version');
            expect(response.body).toHaveProperty('platform');
            expect(response.body.application).toBe('friendly-octo-lamp');
        });
    });

    describe('GET /nonexistent', () => {
        it('should return 404 for non-existent routes', async () => {
            const response = await request(app)
                .get('/nonexistent')
                .expect(404);
            
            expect(response.body).toHaveProperty('error');
            expect(response.body.error).toBe('Not Found');
        });
    });
});