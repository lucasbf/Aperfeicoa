using Microsoft.AspNetCore.Mvc;

namespace Aperfeicoa.Services.Interfaces;

public interface IService<T>
{
    public void Create(T entity);

    public void Remove(T entity);

    public void Update(T entity);

    public T Get(T entity);

    public IEnumerable<T> GetAll();    
}