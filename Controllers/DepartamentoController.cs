using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Aperfeicoa.Models;
using Aperfeicoa.Services.Interfaces;

namespace Aperfeicoa.Controllers;

public class DepartamentoController : Controller
{
    
    private readonly ILogger<DepartamentoController> _logger;
    private readonly IDepartamentoService _service;

    public DepartamentoController(ILogger<DepartamentoController> logger, IDepartamentoService service)
    {
        _logger = logger;
        _service = service;
    }

    public IActionResult Index()
    {
        return View(_service.GetAll());
    }
}