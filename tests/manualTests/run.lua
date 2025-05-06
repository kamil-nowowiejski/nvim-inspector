-- to run this test put ":source" in vim command

require('tests.manualTests.runtimepath')

require('inspector.colorscheme').registerColors()
local sut = require('inspector')
local tests = {
    {
        namespaceParts = {'Root1', 'Part1', 'Part2'},
        testName = 'TestOne',
        duration = '00:00:00.0012265',
        status = 'success',
    },
    {
        namespaceParts = {'Root1', 'Part1', 'Part2'},
        testName = 'TestTwo',
        duration = '00:00:00.009574',
        status = 'failure',
        errorMessage = 'I blew up!',
        stackTrace = {
            { line = 'line 1_1_1', isMyCode = false },
            { line = 'line 1_1_2', isMyCode = true },
            { line = 'line 1_1_3', isMyCode = false },
        }
    },
    {
        namespaceParts = { 'Root1', 'Part1', 'Part3'},
        testName = 'TestInBetween',
        duration = '00:00:00.008346573',
        status = 'success'
    },
    {
        namespaceParts = {'Root1', 'Part1'},
        testName = 'TestThree',
        duration = '00:00:00.087563',
        status = 'failure',
        errorMessage = 'kaboom!',
        stackTrace = {
            { line = 'line 1_2_1', isMyCode = false },
            { line = 'line 1_2_2', isMyCode = false },
            { line = 'line 1_2_3', isMyCode = true },
        }
    },
    {
        namespaceParts = { 'Root1' },
        testName = 'TestFour',
        duration = '00:00:00.095732',
        status = 'success',
    },
    {
        namespaceParts = { 'Root1' },
        testName = 'TestFive',
        duration = '00:00:00.0993539',
        status = 'success',
    },
    {
        namespaceParts = { 'Root2', 'Namespace1', 'Namespace2' },
        testName = 'TestSix',
        duration = '00:00:00.034350',
        status = 'success',
    },
    {
        namespaceParts = { 'Root2', 'Namespace1', 'Namespace2' },
        testName = 'TestSeven',
        duration = '00:00:00.0212435',
        status = 'failure',
        errorMessage = 'Expected number 2 but got 4',
        stackTrace = {
            { line = 'line 2_1_1', isMyCode = false },
            { line = 'line 2_1_2', isMyCode = false },
            { line = 'line 2_1_3', isMyCode = false },
        }
    },
    {
        namespaceParts = { 'Root2', 'Namespace1' },
        testName = 'TestEight',
        duration = '00:00:00.0350462',
        status = 'failure',
        errorMessage = 'Expected number empty list',
        stackTrace = {
            { line = 'line 2_2_1', isMyCode = true },
            { line = 'line 2_2_2', isMyCode = true },
            { line = 'line 2_2_3', isMyCode = true },
        }
    },
    {
        namespaceParts = { 'Big stack trace' },
        testName = 'Failure with big stack trace',
        status = 'failure',
        errorMessage = 'System.InvalidOperationException: The operation cannot be completed because the database connection is in an invalid state. The connection string might be incorrect, or the server may be unavailable. Please check your network connection and ensure the database server is running. If the problem persists, contact your system administrator.',
        stackTrace = {
            { line = 'at DataAccess.DatabaseConnection.ExecuteQuery(String query) in C:\\Projects\\EnterpriseApp\\DataAccess\\DatabaseConnection.cs:line 157', isMyCode = true },
            { line = 'at DataAccess.UserRepository.GetUserByUsername(String username) in C:\\Projects\\EnterpriseApp\\DataAccess\\UserRepository.cs:line 42', isMyCode = true },
            { line = 'at BusinessLogic.AuthenticationService.ValidateUser(String username, String password) in C:\\Projects\\EnterpriseApp\\BusinessLogic\\AuthenticationService.cs:line 78', isMyCode = true },
            { line = 'at BusinessLogic.LoginManager.ProcessLogin(LoginRequest request) in C:\\Projects\\EnterpriseApp\\BusinessLogic\\LoginManager.cs:line 103', isMyCode = true },
            { line = 'at API.Controllers.AuthController.Login(LoginViewModel model) in C:\\Projects\\EnterpriseApp\\API\\Controllers\\AuthController.cs:line 55', isMyCode = true },
            { line = 'at lambda_method(Closure , Object , Object[] )', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.SyncActionResultExecutor.Execute(IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeActionMethodAsync()', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeNextActionFilterAsync()', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.InvokeInnerFilterAsync()', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|24_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.InvokeFilterPipelineAsync()', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)', isMyCode = false },
            { line = 'at Microsoft.AspNetCore.Diagnostics.DeveloperExceptionPageMiddleware.Invoke(HttpContext context)', isMyCode = false },
        }
    }
}

sut.showTests(tests)
