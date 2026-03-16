const swaggerJsdoc = require('swagger-jsdoc');
const path = require('path');
const packageJson = require('../../package.json');

const options = {
    definition: {
        openapi: '3.0.0',
        info: {
            title: 'Painamnae API',
            version: packageJson.version,
            description: 'API for ride sharing (users, drivers, vehicles, routes, bookings).',
        },
        components: {
            securitySchemes: {
                bearerAuth: {
                    type: 'http',
                    scheme: 'bearer',
                    bearerFormat: 'JWT',
                },
            },
        },
        security: [
            {
                bearerAuth: [],
            },
        ],
    },
    // Resolve from this file location so it still works after folder structure changes.
    apis: [
        path.join(__dirname, '..', 'routes', '*.js'),
        path.join(__dirname, '..', 'docs', '*.js'),
    ],
    // apis: ['./src/routes/**/*.js'],
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;