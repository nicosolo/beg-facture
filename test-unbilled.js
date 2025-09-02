// Test script for unbilled activities endpoint
async function testUnbilledActivities() {
    try {
        // First, get the JWT token (you may need to adjust credentials)
        const loginResponse = await fetch('http://localhost:4983/user/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                email: 'js@beg-geol.ch', // Using an actual user from the database
                password: 'password123' // Default password from import
            })
        });

        if (!loginResponse.ok) {
            console.error('Login failed:', await loginResponse.text());
            return;
        }

        const { token } = await loginResponse.json();
        console.log('✓ Login successful');

        // Now test the unbilled activities endpoint
        // You'll need to replace projectId with an actual project ID from your database
        const projectId = 1; // Replace with actual project ID
        
        const response = await fetch(`http://localhost:4983/invoices/unbilled-activities?projectId=${projectId}`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (!response.ok) {
            console.error('Failed to fetch unbilled activities:', response.status, await response.text());
            return;
        }

        const data = await response.json();
        console.log('✓ Unbilled activities fetched successfully');
        console.log('Activities count:', data.activities?.length || 0);
        console.log('Rate classes:', data.rates?.length || 0);
        console.log('Total kilometers:', data.totalKilometers);
        console.log('Total expenses:', data.totalExpenses);
        console.log('Total disbursements:', data.totalDisbursements);
        console.log('Activity IDs:', data.activityIds?.length || 0);
        
        if (data.rates && data.rates.length > 0) {
            console.log('\nRate breakdown:');
            data.rates.forEach(rate => {
                console.log(`  Class ${rate.rateClass}: ${rate.base}h base, ${rate.adjusted}h adjusted`);
            });
        }

    } catch (error) {
        console.error('Test failed:', error);
    }
}

// Run the test
testUnbilledActivities();