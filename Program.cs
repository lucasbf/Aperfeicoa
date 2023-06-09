using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Aperfeicoa.Data;
using Aperfeicoa.Services;
using Aperfeicoa.Services.Interfaces;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddDbContext<AcademicoContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("Academico") ?? 
    throw new InvalidOperationException("Connection string 'AcademicoContext' not found.")
));
builder.Services.AddScoped<IDepartamentoService, DepartamentoDBContext>();
builder.Services.AddScoped<IEmpregadoService, EmpregadoDBContext>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
